//
//  Alarm.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 28.12.2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import Foundation
import RealmSwift

class Alarm: Object {
    
    // MARK: - Public Properties
    
    @objc dynamic var identifaer = 0
    @objc dynamic var date = Date()
    @objc dynamic var status = false
    @objc dynamic var image: Data? = nil
    @objc dynamic var sound: String? = nil
}


