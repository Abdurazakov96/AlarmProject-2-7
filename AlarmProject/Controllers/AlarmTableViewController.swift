//
//  AlarmTableViewController.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 16.12.2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit
import RealmSwift

class AlarmTableViewController: UITableViewController, ViewControllerOutputProtocol, alarmTableViewCellDelegate {
    
    // MARK: - Public Properties
    
    var bool: Bool?
    var alarmsList: Results<Alarm>!
    var arrayOfAlarm: [Date] = []
    var alarmBool: Bool?
    var boolForNavigationBar = true
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshToDate()
        setupNavigationBar()
        obtainData()
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var k = 0
        
        if alarmsList.count != 0 {
            for index in 0...alarmsList.count - 1 {
                if alarmsList[index].status == true {
                    k += 1
                }
                
            }
            
        }
        
        if k < 8 {
            super.prepare(for: segue, sender: sender)
            
            if segue.identifier == "addSegue",
                let view = segue.destination as? ViewController {
                view.output = self
            }
            
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Количество активных будильников не должно превышать 8", comment: "alarm limit"), message: nil , preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsList.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        editButtonItem.title = NSLocalizedString("Удалить", comment: "delete")
        editButtonItem.tintColor = .black
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Удалить", comment: "delete")) { (action, view, completion) in
            self.deleteAlarm(at: indexPath)
            print("delete Alarm")
            completion(true)
        }
        deleteAction.title = "❌"
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let realm = try! Realm()
        
        alarmsList = realm.objects(Alarm.self)
        alarmsList = alarmsList.sorted(byKeyPath: "date", ascending: true)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "identificator")  as? AlarmTableViewCell
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        cell?.alarmLabel.text = (dateFormatter.string(from: (alarmsList[indexPath.row].date)))
        cell?.delegate = self
        cell?.index = indexPath
        cell?.assignStatus(alarm: alarmsList[indexPath.row])
        cell?.view.layer.cornerRadius = (cell?.view.bounds.height)!/2
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Private Methods
    
    private func setupTableView(){
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    private func obtainData() {
        let realm = try! Realm()
        alarmsList = realm.objects(Alarm.self)
        alarmsList = alarmsList.sorted(byKeyPath: "date", ascending: true)
    }
    
    private func setupNavigationBar() {
        
        navigationItem.title = NSLocalizedString("Будильник", comment: "Будильник")
        
        let deleteButton = UIBarButtonItem(title: NSLocalizedString("Удалить", comment: "delete"),
                                           style: .done,
                                           target: self,
                                           action: #selector(editAction))
        
        navigationItem.leftBarButtonItem = deleteButton
    }
    
    private func deleteAlarm(at indexPath: IndexPath) {
          
          let realm = try! Realm()
          
          for index in 1...7 {
              Notification.shared.deleteAlarm(identifaer: (String(self.alarmsList[indexPath.row].identifaer + index)))
              print((self.alarmsList[indexPath.row].identifaer + index))
          }
          
          Notification.shared.deleteAlarm(identifaer: (String(self.alarmsList[indexPath.row].identifaer)))
          print(self.alarmsList[indexPath.row].identifaer)
          
          try! realm.write {
              realm.delete(self.alarmsList[indexPath.row])
          }
          
          self.tableView.reloadData()
          //        tableView.reloadData()
          alarmsList = realm.objects(Alarm.self)
          alarmsList = alarmsList.sorted(byKeyPath: "date", ascending: true)
      }
    
    private func refreshToDate() {
          let realm = try! Realm()
          
          if realm.objects(Alarm.self).count != 0 {
              for index in 0...realm.objects(Alarm.self).count - 1 {
                  if Date().timeIntervalSince(realm.objects(Alarm.self)[index].date) > 86400 {
                      var day = 0
                      day = Int(Date().timeIntervalSince(realm.objects(Alarm.self)[index].date) / 86400)
                      print("day = \(day)")
                      let alarm =  realm.objects(Alarm.self)[index]
                      
                      try! realm.write {
                          alarm.date += TimeInterval(86400 * day)
                        alarm.status = false
                      }
                      
                  }
                  
                  let dateNow = Date()
                  let dateFormatter = DateFormatter()
                  dateFormatter.dateStyle = .short
                  let dateNowString = dateFormatter.string(from: dateNow)
                  let dateString = dateFormatter.string(from: realm.objects(Alarm.self)[index].date)
                  
                  if dateNowString != dateString {
                      try! realm.write {
                          realm.objects(Alarm.self)[index].date += TimeInterval(86400)
                      }
                      
                  }
                  
              }
              
          }
          
      }
    
        // MARK: - Public Methods
    
    func addAlarmForDate(_ date: Date, _ imageData: Data?, sound: String, identifaer: String) {
        let alarm = Alarm()
        alarm.date = date
        alarm.identifaer = Int(identifaer)!
        alarm.status = true
        alarm.image = imageData
        alarm.sound = sound
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(alarm)
            
            self.tableView.reloadData()
        }
    }
    
    func didChangeStatus(isOn: Bool, indexPath: IndexPath, boolForAlert: Bool?) {
        
        if boolForAlert == true {
            let alert = UIAlertController(title: NSLocalizedString("Количество активных будильников не должно превышать 8", comment: "alarm limit"), message: nil , preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        } else {
            let realm = try! Realm()
            
            try! realm.write {
                alarmsList[indexPath.row].status = isOn
            }
            
            if isOn {
                if Double(self.alarmsList[indexPath.row].date.timeIntervalSinceNow) >= 0 {
                    Notification.shared.requestNotification(identificator: String(alarmsList[indexPath.row].identifaer), sound: self.alarmsList[indexPath.row].sound!, timeForAlarm: Double(self.alarmsList[indexPath.row].date.timeIntervalSinceNow))
                } else {
                    Notification.shared.requestNotification(identificator: String(alarmsList[indexPath.row].identifaer), sound: self.alarmsList[indexPath.row].sound!, timeForAlarm: 24 * 60 * 60 + Double(self.alarmsList[indexPath.row].date.timeIntervalSinceNow))
                }
                
                print("isOn")
                
            } else {
                
                for index in 0...7 {
                    Notification.shared.deleteAlarm(identifaer: String(alarmsList[indexPath.row].identifaer + index))
                    print("delete \(alarmsList[indexPath.row].identifaer + index) identificator ")
                }
                
            }
            
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func alarmAction(_ sender: Any) {
        tableView.reloadData()
    }
    
    // MARK: - Objc Method
    
    @objc private func editAction() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        boolForNavigationBar.toggle()
        if boolForNavigationBar {
           navigationItem.leftBarButtonItem?.title = NSLocalizedString("Удалить", comment: "delete")
        } else {
        navigationItem.leftBarButtonItem?.title = NSLocalizedString("Отменить", comment: "cancel")
        }
        
        if alarmsList.count == 0 {
            navigationItem.leftBarButtonItem?.title = NSLocalizedString("Удалить", comment: "delete")
        }
        
    }
    
}


