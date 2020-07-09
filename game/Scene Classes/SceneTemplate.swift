//
//  SceneTemplate.swift
//  game
//
//  Created by Leo Li on 2020/6/13.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import SpriteKit

class SceneTemplate: SKScene {
    var patty: Patty!
    var doorHandle: SKSpriteNode!
    var idleCycle: SKAction!
    var background: SKSpriteNode!
    var textShadow: SKSpriteNode!
    var dialogueText: SKSpriteNode!
    var talkerHead: SKSpriteNode!
    
    var canTouch = true
    
    override func didMove(to view: SKView) {
        self.patty = self.childNode(withName: "patty body") as? Patty
        self.patty.setupBodyParts()
        self.patty.idleCycle()
        
        self.background = self.childNode(withName: "background") as? SKSpriteNode
        self.doorHandle = self.childNode(withName: "door handle hitbox")?.childNode(withName: "door handle") as? SKSpriteNode
        self.textShadow = self.childNode(withName: "text shadow") as? SKSpriteNode
        
        self.dialogueText = self.textShadow.childNode(withName: "dialogue text") as? SKSpriteNode
        self.talkerHead = self.textShadow.childNode(withName: "talker head") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let t = touches.first {
            let location = t.location(in: self)
            
            // TODO: - Disable tapping before current action triggered by tap finishes
            
            if self.patty.contains(location) || canTouch == false {
                return
            }
            
            self.canTouch = false
            
            // Adjust Face Direction
            self.patty.xScale = location.x < self.patty.frame.midX ? abs(self.patty.xScale) * -1 : abs(self.patty.xScale)
            
            if self.childNode(withName: "door handle hitbox")!.contains(location){
                self.patty.touch(location) {
                    self.doorHandleRotate()
                    self.pattyRestoreRestPose()
                }
            } else {
                self.patty.walkTo(location) {
                    self.pattyRestoreRestPose()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
