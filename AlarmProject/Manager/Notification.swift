//
//  notification.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 14.12.2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

//import UIKit
import UserNotifications
import RealmSwift

class Notification: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: - Public Properties
    
    let notification = UNUserNotificationCenter.current()
    static var shared = Notification()
    
    // MARK: - Public Methods
    
    func requestAutorization() {
        notification.requestAuthorization(options: [.alert, .sound, .badge]) { (status, error) in
            
            if status == false {
                DispatchQueue.main.async {
                     let storyboard = UIStoryboard(name: "Main", bundle: nil)
                     let vc = storyboard.instantiateViewController(withIdentifier: "555") as? NotificationOffViewController
                     UIApplication.shared.keyWindow?.rootViewController = vc
                 }
            
            }
            
            guard status else {return}
            self.getNotificationSettings()
        }
        
    }
    
    func getNotificationSettings() {
        notification.getNotificationSettings { (settings) in
            print("settings")
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let realm = try! Realm()
        let alarms = realm.objects(Alarm.self)
        
        print("this identifaer issss \(response.notification.request.identifier)")
        print(alarms.count)
        
        for index in 0...alarms.count - 1 {
            if response.notification.request.identifier == "\(alarms[index].identifaer)" {
                if alarms[index].image != nil {
                    print("загрузился первый идентификатор")
                    ArKitViewController.data = alarms[index].image!
                    ArKitViewController.index = index
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "111") as? ArKitViewController
                    UIApplication.shared.keyWindow?.rootViewController = vc
                } else {
                    print("Cработало уведомление \(alarms[index].identifaer)")
                    deleteAlarm(identifaer: response.notification.request.identifier)
                }
                
            } else if response.notification.request.identifier != "alarm"   {
                let indexForOff = Int(response.notification.request.identifier)! / 8
                
                if indexForOff == 0 || Int(response.notification.request.identifier) == 8   {
                    if alarms[0].image != nil {
                        if Int(response.notification.request.identifier)! % 8 == 0 {
                            deleteAlarm(identifaer: response.notification.request.identifier)
                            
                            try! realm.write {
                                alarms[0].status = false
                            }
                            
                        } else {
                            ArKitViewController.data = alarms[0].image!
                            ArKitViewController.index = 0
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "111") as? ArKitViewController
                            UIApplication.shared.keyWindow?.rootViewController = vc
                
                        }
                        
                    } else {
                        if Int(response.notification.request.identifier)! % 8 == 0 {
                            deleteAlarm(identifaer: response.notification.request.identifier)
                            
                            try! realm.write {
                                alarms[0].status = false
                            }
                            
                        } else {
                            deleteAlarm(identifaer: response.notification.request.identifier)
                        }
                        
                    }
                    
                } else if indexForOff != 0  {
                    
                    let n = Int(response.notification.request.identifier)! - alarms[index].identifaer
                    
                    switch n {
                    case 1, 2, 3, 4, 5, 6:
                        if alarms[index].image != nil {
                            print("загрузился первый идентификатор")
                            ArKitViewController.data = alarms[index].image!
                            ArKitViewController.index = index
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "111") as? ArKitViewController
                            UIApplication.shared.keyWindow?.rootViewController = vc
                        } else {
                            deleteAlarm(identifaer: response.notification.request.identifier)
                        }
                        
                    case 7:
                        
                        try! realm.write {
                            alarms[index].status = false
                        }
                        
                        deleteAlarm(identifaer: response.notification.request.identifier)
                    default: break
                    }
                    
                }
                
            }
            
        }
        completionHandler()
    }
    
    func requestForAlarm() {
        let content = UNMutableNotificationContent()
        let contentBody = NSLocalizedString("Для срабатывания будильника, беззвучный режим должен быть отключен", comment: "request For Alarm")
        
        content.title = "Alarm"
        content.badge = 1
        content.body = contentBody
        content.categoryIdentifier = "userAction"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  1, repeats: false)
        
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        let realm = try! Realm()
        let alarms = realm.objects(Alarm.self)
        var boolForAlarm = false
        
        if alarms.count != 0 {
            for index in 0...alarms.count - 1 {
                if alarms[index].status == true {
                    boolForAlarm = true
                }
                
            }
            
            if boolForAlarm == true {
                notification.add(request) { (error) in
                    guard let error = error else {return}
                    print(error)
                }
                
            }
            
        }
        
    }
    
    func requestNotification(identificator: String?, sound: String, timeForAlarm: Double) {
        let content = UNMutableNotificationContent()
        var timeForRepeat = timeForAlarm
        
        content.title = "Alarm"
        content.badge = 1
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: sound))
        content.body = NSLocalizedString("Будильник", comment: "request Notification")
        
        content.categoryIdentifier = "userAction"
        
        var trigger = UNTimeIntervalNotificationTrigger(timeInterval:  timeForRepeat, repeats: false)
        let realm = try! Realm()
        
        if identificator == nil {
            let alarms = realm.objects(Alarm.self)
            var maxIdent = 1
            
            if alarms.count != 0 {
                for index in 0...alarms.count - 1  {
                    if alarms[index].identifaer > maxIdent {
                        maxIdent = alarms[index].identifaer
                    }
                    
                }
                
                let identifier = "\((maxIdent) + 8)"
                
                print(identifier)
                
                
                for index in 0...7 {
                    let identifierForAlarm: String = "\(Int(identifier)! + index)"
                    print("this is \(identifierForAlarm)")
                    print("this is \(timeForRepeat)")
                    
                    if index == 7 {
                        content.body = NSLocalizedString("Будильник отключен автоматически", comment: "alarm off automatic")
                        
                    }
                    
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval:  timeForRepeat, repeats: false)
                    
                    timeForRepeat += 60
                    
                    let request = UNNotificationRequest(identifier: identifierForAlarm, content: content, trigger: trigger)
                    
                    notification.add(request) { (error) in
                        guard let error = error else {return}
                        print(error)
                    }
                    
                }
                
            } else {
                var identifier = "\(maxIdent)"
                
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                notification.add(request) { (error) in
                    guard let error = error else {return}
                    print(error)
                }
                
                for index in 1...7 {
                    identifier = "\(maxIdent + index)"
                    timeForRepeat += 60
                    print("this is \(identifier)")
                    print("this is \(timeForAlarm)")
                    
                    if index == 7 {
                        content.body = NSLocalizedString("Будильник отключен автоматически", comment: "alarm off automatic")
                        
                    }
                    
                    trigger = UNTimeIntervalNotificationTrigger(timeInterval:  timeForRepeat, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    notification.add(request) { (error) in
                        guard let error = error else {return}
                        print(error)
                    }
                    
                }
                
            }
            
        } else {
            
            for index in 0...7 {
                trigger = UNTimeIntervalNotificationTrigger(timeInterval:  timeForRepeat, repeats: false)
                
                if index == 7 {
                    content.body = NSLocalizedString("Будильник отключен автоматически", comment: "alarm off automatic")
                    
                }
                
                let request = UNNotificationRequest(identifier: (String(Int(identificator!)! + index)), content: content, trigger: trigger)
                
                notification.add(request) { (error) in
                    guard let error = error else {return}
                    print(error)
                }
                
                timeForRepeat += 60
                
                print("On \(String(Int(identificator!)! + index)) identificator")
            }
            
        }
        
        let category = UNNotificationCategory(identifier: "userAction", actions: [], intentIdentifiers: [], options: [])
        
        notification.setNotificationCategories([category])
        print(notification.getPendingNotificationRequests(completionHandler: { error in
            
        }))
        
    }
    
    func deleteAlarm(identifaer: String) {
        notification.removePendingNotificationRequests(withIdentifiers: [identifaer])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("dddd \(notification.request.identifier)")
        
        completionHandler([.alert, .sound])
        
    }
    
    func stopAlarms(_ index: Int) {
        let realm = try! Realm()
        let alarms = realm.objects(Alarm.self)
        
        deleteAlarm(identifaer: "\(index)")
        
        try! realm.write {
            alarms[index].status = false
        }
        
        for i in 1...7 {
            deleteAlarm(identifaer: "\(alarms[index].identifaer + i)")
        }
        
    }
    
}



