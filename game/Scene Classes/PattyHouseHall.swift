//
//  PattyHouseHall.swift
//  game
//
//  Created by Leo Li on 2020/6/11.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import SpriteKit
import GameplayKit

class PattyHouseHall: SceneTemplate {
    var clockHourHand: SKSpriteNode!
    var clockMinuteHand: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.clockHourHand = self.background.childNode(withName: "clock hour hand") as? SKSpriteNode
        self.clockMinuteHand = self.background.childNode(withName: "clock minute hand") as? SKSpriteNode
        
        self.spinClockHands()
    }
    
    func spinClockHands(){
        self.clockHourHand.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi * -2, duration: 120)))
        self.clockMinuteHand.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi * -2, duration: 60)))
    }
}
