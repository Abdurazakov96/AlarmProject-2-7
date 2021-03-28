//
//  AlarmTableViewCell.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 31.12.2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit
import RealmSwift

class AlarmTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var alarmSwitch: UISwitch!
    @IBOutlet var view: UIView!
    
    // MARK: - Public Properties
    
        let realm = try! Realm()
    var delegate: alarmTableViewCellDelegate?
    var index: IndexPath?

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Public Methods
    
    func assignStatus(alarm: Alarm) {
        alarmSwitch.isOn = alarm.status
    }
    
    func editView(){
        view.layer.cornerRadius = (view.bounds.height)/2
    }
    
    // MARK: - IBActions
    
    @IBAction func SwitchButtonOn(_ sender: UISwitch) {
        var alarmsList: Results<Alarm>!
        var k = 0
        
        alarmsList = realm.objects(Alarm.self)
        alarmsList = alarmsList.sorted(byKeyPath: "date", ascending: true)
        
        if alarmsList.count != 0 {
            for index in 0...alarmsList.count - 1 {
                if alarmsList[index].status == true {
                    k += 1
                }
                
            }
            
        }
        
        guard let index = index else {return}
        
        if k < 8 {
            delegate?.didChangeStatus(isOn: sender.isOn, indexPath: index, boolForAlert: nil)
            print("elele 1")
        } else if k >= 8 && sender.isOn == false {
            delegate?.didChangeStatus(isOn: sender.isOn, indexPath: index, boolForAlert: nil)
            print("elele 2")
        } else if k >= 8 && sender.isOn == true {
            sender.isOn = false
            delegate?.didChangeStatus(isOn: sender.isOn, indexPath: index, boolForAlert: true)
            print("elele 3")
        }
        
    }
    
}


