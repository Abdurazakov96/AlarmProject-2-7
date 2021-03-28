//
//  CustonNavigationController.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 02.04.2020.
//  Copyright © 2020 Магомед Абдуразаков. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    
    
    override var shouldAutorotate: Bool {
         return false
     }
     
     override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
         return .portrait
     }
   
}

