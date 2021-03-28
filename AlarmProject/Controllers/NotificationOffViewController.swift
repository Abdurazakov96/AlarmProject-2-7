//
//  NotificationOffViewController.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 19.04.2020.
//  Copyright © 2020 Магомед Абдуразаков. All rights reserved.
//

import UIKit

class NotificationOffViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var label: UILabel!
    var OnNotification: UIButton!
    var status = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        initViews()
        createWindow()
        editProperties()

    }
    
    // Private Methods
    
    private func initViews() {
        self.label = UILabel()
        self.OnNotification = UIButton()
        
        label?.translatesAutoresizingMaskIntoConstraints = false
        OnNotification?.translatesAutoresizingMaskIntoConstraints = false
        
        OnNotification.addTarget(.none, action: #selector(OpenSettings(_:)), for: .allTouchEvents)
        
        view.addSubview(label)
        view.addSubview(OnNotification)
    }
    
    private func createWindow(){
        
        let labelTopConstraint = NSLayoutConstraint(item: label!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: self.view.bounds.height / 5 )
        
        let labelLeftConstraint = NSLayoutConstraint(item: label!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 0.05, constant: 0)
        
        let labelRightConstraint = NSLayoutConstraint(item: label!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 0.05, constant: 0)
        
        let labelPosition = NSLayoutConstraint(item: label!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let buttonTopConstraint = NSLayoutConstraint(item: OnNotification!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: self.view.bounds.height / 2 / 3 )
        
        let buttonPosition = NSLayoutConstraint(item: OnNotification!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let buttonHeight = NSLayoutConstraint(item: OnNotification!, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 50)
        
        let buttonWidth = NSLayoutConstraint(item: OnNotification!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.bounds.width / 1.4)
        
        let buttonBottomConstraint = NSLayoutConstraint(item: OnNotification!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -200)
        
        self.view.addConstraints([labelTopConstraint, labelRightConstraint, labelLeftConstraint, labelPosition, buttonTopConstraint, buttonPosition, buttonHeight, buttonWidth, buttonBottomConstraint])
    }
    
    private func editProperties() {
        label.text = NSLocalizedString("Требуется разрешение на отправку уведомлений для работы будильника", comment: "time")
        label.font = label.font.withSize(26)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        
        
        OnNotification.setTitle(NSLocalizedString("Разрешить уведомления в настройках телефона", comment: "photo"), for: .normal)
        OnNotification.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        OnNotification.layer.cornerRadius = 12.5
        OnNotification.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        OnNotification.titleLabel?.numberOfLines = 0
        OnNotification.titleLabel?.textAlignment = .center
        OnNotification.setTitleColor(.black, for: .normal)
        
        self.view.backgroundColor = UIColor.white
        
    }
    
     func checkStatus() {
        
        Notification.shared.notification.requestAuthorization(options: [.alert, .sound, .badge]) { (status, error) in
            if status {
                DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "444") as? UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = vc
                }
            }
            
        }
        
    }
    
    // MARK: - IBAction Method
    
    @IBAction func OpenSettings(_ sender: Any) {
        
//        checkStatus()
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
            
        }
        
    }
    
}


