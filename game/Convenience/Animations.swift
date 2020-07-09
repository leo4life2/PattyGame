//
//  Animations.swift
//  game
//
//  Created by Leo Li on 2020/6/13.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import SpriteKit

extension SceneTemplate {

    func doorHandleRotate(){
        let rotateAction = SKAction.run {
            self.doorHandle.run(SKAction.rotate(byAngle: .pi/2, duration: Constants.doorHandleRotateTime))
        }
        let rotateBackAction = SKAction.run {
            self.doorHandle.run(SKAction.rotate(byAngle: -.pi/2, duration: Constants.doorHandleRotateTime))
        }
        
        let waitForHandAction = SKAction.wait(forDuration: Constants.touchObjActionTime + 0.3)
        
        let waitAction = SKAction.wait(forDuration: Constants.doorHandleRotateTime)
        
        self.run(SKAction.sequence([waitForHandAction, rotateAction, waitAction, rotateBackAction]))
    }
    
    func pattyRestoreRestPose() {
        
        self.patty.rightUpperArm.zRotation = 0
        self.patty.leftUpperArm.zRotation = 0
        
        self.patty.rightLeg.zRotation = 0
        self.patty.rightFoot.zRotation = 0
        self.patty.leftLeg.zRotation = 0
        self.patty.leftFoot.zRotation = 0
        
        self.patty.position.y = Constants.pattyYValue
        
        self.canTouch = true
    }
    
    func showDialogueWith(texture: SKTexture, text: String) {
        let imgNode = self.textShadow.childNode(withName: "img") as! SKSpriteNode
        let textNode = self.textShadow.childNode(withName: "text") as! SKLabelNode
        
        imgNode.texture = texture
        textNode.text = text
        
        self.textShadow.isHidden = false
    }
    
}
