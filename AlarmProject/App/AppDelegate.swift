//
//  AppDelegate.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 14.12.2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Public Properties
    
    let notification = Notification()
    var window: UIWindow?
    
    // MARK: - Public Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Notification.shared.requestAutorization()
        Notification.shared.notification.delegate = Notification.shared
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Notification.shared.requestForAlarm()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Notification.shared.requestForAlarm()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        Notification.shared.requestAutorization()
        
        guard  let vc = UIApplication.shared.keyWindow?.rootViewController as? NotificationOffViewController else {return}
        vc.checkStatus()
        
    }
    
}


