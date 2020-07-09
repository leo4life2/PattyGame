//
//  Utilities.swift
//  game
//
//  Created by Leo Li on 2020/6/11.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import SpriteKit
import UIKit

extension CGFloat {
    func degToRad() -> CGFloat{
        return self * .pi / 180
    }
}

extension CGPoint {
    func XDistanceTo(point: CGPoint) -> CGFloat {
        return abs(point.x - self.x)
    }
    func YDistanceTo(point: CGPoint) -> CGFloat {
        return abs(point.y - self.y)
    }
    
    func XDisplacementTo(point: CGPoint) -> CGFloat {
        return point.x - self.x
    }
    func YDisplacementTo(point: CGPoint) -> CGFloat {
        return point.y - self.y
    }
    
}
