//
//  Constants.swift
//  game
//
//  Created by Leo Li on 2020/6/13.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import SpriteKit

struct Constants {
    // MARK: - SKAction Speeds
    // Default movement covers 300 pts in 0.2 sec
    static let walkStepSpeed = 0.2
    static let idleCycleSpeed = 1.0
    static let headLookActionTime = 0.3
    static let touchObjActionTime = 0.8
    static let objPickupDistance: CGFloat = 150.0
    static let doorHandleRotateTime = 0.3
    
    // MARK: - Positions
    static let pattyYValue: CGFloat = -66.0
}
