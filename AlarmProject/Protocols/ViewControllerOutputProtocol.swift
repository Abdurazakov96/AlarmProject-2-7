//
//  ViewControllerOutputProtocol.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 18.12.2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import Foundation

protocol  ViewControllerOutputProtocol: class {
    
    // MARK: - Public Methods
    
    func addAlarmForDate(_ date: Date,_ imageData: Data?, sound: String, identifaer: String)
}


