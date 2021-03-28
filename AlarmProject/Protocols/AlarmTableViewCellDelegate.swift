//
//  StatusProtocol.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 29.01.2020.
//  Copyright © 2020 Магомед Абдуразаков. All rights reserved.
//

import Foundation

protocol  alarmTableViewCellDelegate: class {
    
    // MARK: - Public Methods
    
    func didChangeStatus(isOn: Bool, indexPath: IndexPath, boolForAlert: Bool?)
}

