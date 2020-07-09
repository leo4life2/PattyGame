//
//  Character.swift
//  game
//
//  Created by Leo Li on 2020/6/13.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import UIKit
import SpriteKit

class Character: SKSpriteNode {
    var head: SKSpriteNode!
    
    var leftUpperArm: SKSpriteNode!
    var rightUpperArm: SKSpriteNode!
    
    var leftLowerArm: SKSpriteNode!
    var rightLowerArm: SKSpriteNode!
    
    var leftHand: SKSpriteNode!
    var rightHand: SKSpriteNode!
    
    var leftLeg: SKSpriteNode!
    var rightLeg: SKSpriteNode!
    
    var leftFoot: SKSpriteNode!
    var rightFoot: SKSpriteNode!
    
    public func setupBodyParts(){
        self.head = self.childNode(withName: "head") as? SKSpriteNode
        
        self.leftUpperArm = self.childNode(withName: "left upper arm") as? SKSpriteNode
        self.rightUpperArm = self.childNode(withName: "right upper arm") as? SKSpriteNode
        
        self.leftLowerArm = leftUpperArm.childNode(withName: "left lower arm") as? SKSpriteNode
        self.rightLowerArm = rightUpperArm.childNode(withName: "right lower arm") as? SKSpriteNode
        
        self.leftHand = leftLowerArm.childNode(withName: "left hand") as? SKSpriteNode
        self.rightHand = rightLowerArm.childNode(withName: "right hand") as? SKSpriteNode
        
        self.leftLeg = self.childNode(withName: "left leg") as? SKSpriteNode
        self.rightLeg = self.childNode(withName: "right leg") as? SKSpriteNode
        
        self.leftFoot = leftLeg.childNode(withName: "left foot") as? SKSpriteNode
        self.rightFoot = rightLeg.childNode(withName: "right foot") as? SKSpriteNode
        
        // IK Constraints
        rightLowerArm.reachConstraints = SKReachConstraints(lowerAngleLimit: CGFloat(0), upperAngleLimit: CGFloat(150).degToRad())
    }
    
    // MARK: - Character Animations
    
    func idleCycle(){
        let step1 = SKAction.run {
            self.rightUpperArm.run(SKAction.rotate(byAngle: CGFloat(-3).degToRad(), duration: Constants.idleCycleSpeed))
            self.leftUpperArm.run(SKAction.rotate(byAngle: CGFloat(3).degToRad(), duration: Constants.idleCycleSpeed))
            
            self.head.run(SKAction.rotate(byAngle: CGFloat(-3).degToRad(), duration: Constants.idleCycleSpeed))
        }
        let step2 = SKAction.run {
            self.rightUpperArm.run(SKAction.rotate(byAngle: CGFloat(3).degToRad(), duration: Constants.idleCycleSpeed))
            self.leftUpperArm.run(SKAction.rotate(byAngle: CGFloat(-3).degToRad(), duration: Constants.idleCycleSpeed))
            
            self.head.run(SKAction.rotate(byAngle: CGFloat(3).degToRad(), duration: Constants.idleCycleSpeed))
        }
        let blinkAction = SKAction.run {
            self.head.run(SKAction.animate(with: [Textures.pattyHead, Textures.pattyHeadBlink1, Textures.pattyHeadBlink2, Textures.pattyHeadBlink1, Textures.pattyHead], timePerFrame: 0.1))
        }
        
        let waitAction = SKAction.wait(forDuration: Constants.idleCycleSpeed)
        
        let idleCycle = SKAction.repeatForever(SKAction.sequence([step1, waitAction, step2, waitAction, step1, waitAction, step2, blinkAction, waitAction]))
        self.run(idleCycle, withKey: "idleCycle")
        
    }
    
    func touch(_ location: CGPoint, completion: @escaping () -> Void = { }){
        func lookAtObjectThenTouch() {
            
            let dx = self.head.position.XDisplacementTo(point: location)
            let dy = self.head.position.YDisplacementTo(point: location)
            
            var angle = atan(dy/abs(dx))
            
            angle = abs(angle) > CGFloat(15).degToRad() ? CGFloat(15).degToRad() * -CGFloat(angle.sign.rawValue * 2 - 1) : angle
            
            let lookAtTouchableAction = SKAction.run {
                self.head.run(SKAction.rotate(toAngle: angle, duration: Constants.headLookActionTime))
            }
            
            let touchWithRightArm = SKAction.run {
                self.rightHand.run(SKAction.reach(to: location, rootNode: self.rightUpperArm, duration: Constants.touchObjActionTime))
            }
            
            let restoreArms = SKAction.run {
                self.rightUpperArm.run(SKAction.rotate(toAngle: 0, duration: Constants.touchObjActionTime))
                self.rightLowerArm.run(SKAction.rotate(toAngle: 0, duration: Constants.touchObjActionTime))
            }
            
            let restoreHead = SKAction.run {
                self.head.run(SKAction.rotate(toAngle: 0, duration: Constants.headLookActionTime))
            }
            
            let waitForHeadAction = SKAction.wait(forDuration: Constants.headLookActionTime)
            let waitForArmAction = SKAction.wait(forDuration: Constants.touchObjActionTime)
            
            // Right becomes left when character is flipped. So technically the real left hand is never used.
            self.run(SKAction.sequence([lookAtTouchableAction, waitForHeadAction, touchWithRightArm, waitForArmAction, restoreArms, waitForArmAction, restoreHead]))
        }
        
        
        if self.position.XDistanceTo(point: location) > Constants.objPickupDistance {
            // if too far, walk closer first
            var locToWalkTo = CGPoint()
            if location.x < self.frame.midX{
                // object left of patty
                locToWalkTo = CGPoint(x: location.x + Constants.objPickupDistance, y: location.y)
            } else {
                locToWalkTo = CGPoint(x: location.x - Constants.objPickupDistance, y: location.y)
            }
            
            self.walkTo(locToWalkTo) {
                lookAtObjectThenTouch()
                completion()
            }
        } else {
            lookAtObjectThenTouch()
            completion()
        }
    }
    
    func walkTo(_ location: CGPoint, completion: @escaping () -> Void = { }){
        
        let distance = self.position.XDistanceTo(point: location)
        
        let step1 = SKAction.run {
            self.rightLeg.run(SKAction.rotate(toAngle: CGFloat(10).degToRad(), duration: Constants.walkStepSpeed))
            self.rightFoot.run(SKAction.rotate(toAngle: CGFloat(-20).degToRad(), duration: Constants.walkStepSpeed))
            self.leftLeg.run(SKAction.rotate(toAngle: CGFloat(-5).degToRad(), duration: Constants.walkStepSpeed))
            
            self.leftUpperArm.run(SKAction.rotate(byAngle: CGFloat(-3).degToRad(), duration: Constants.walkStepSpeed))
            self.rightUpperArm.run(SKAction.rotate(byAngle: CGFloat(3).degToRad(), duration: Constants.walkStepSpeed))
            
            self.run(SKAction.move(by: CGVector(dx: 0, dy: 5), duration: Constants.walkStepSpeed))
        }
        
        let step2 = SKAction.run {
            self.rightFoot.run(SKAction.rotate(toAngle: CGFloat(0).degToRad(), duration: Constants.walkStepSpeed))
            self.leftLeg.run(SKAction.rotate(toAngle: CGFloat(-10).degToRad(), duration: Constants.walkStepSpeed))
            
            self.leftUpperArm.run(SKAction.rotate(byAngle: CGFloat(3).degToRad(), duration: Constants.walkStepSpeed))
            self.rightUpperArm.run(SKAction.rotate(byAngle: CGFloat(-3).degToRad(), duration: Constants.walkStepSpeed))
            
            self.run(SKAction.move(by: CGVector(dx: 0, dy: -5), duration: Constants.walkStepSpeed))
        }
        
        let step3 = SKAction.run {
            self.rightLeg.run(SKAction.rotate(toAngle: CGFloat(-5).degToRad(), duration: Constants.walkStepSpeed))
            self.leftLeg.run(SKAction.rotate(toAngle: CGFloat(5).degToRad(), duration: Constants.walkStepSpeed))
            self.leftFoot.run(SKAction.rotate(toAngle: CGFloat(-20).degToRad(), duration: Constants.walkStepSpeed))
            
            self.leftUpperArm.run(SKAction.rotate(byAngle: CGFloat(-3).degToRad(), duration: Constants.walkStepSpeed))
            self.rightUpperArm.run(SKAction.rotate(byAngle: CGFloat(3).degToRad(), duration: Constants.walkStepSpeed))
            
            self.run(SKAction.move(by: CGVector(dx: 0, dy: 5), duration: Constants.walkStepSpeed))
        }
        
        let step4 = SKAction.run {
            self.rightLeg.run(SKAction.rotate(toAngle: CGFloat(-10).degToRad(), duration: Constants.walkStepSpeed))
            self.leftLeg.run(SKAction.rotate(toAngle: CGFloat(15).degToRad(), duration: Constants.walkStepSpeed))
            self.leftFoot.run(SKAction.rotate(toAngle: CGFloat(0).degToRad(), duration: Constants.walkStepSpeed))
            
            self.leftUpperArm.run(SKAction.rotate(byAngle: CGFloat(3).degToRad(), duration: Constants.walkStepSpeed))
            self.rightUpperArm.run(SKAction.rotate(byAngle: CGFloat(-3).degToRad(), duration: Constants.walkStepSpeed))
            
            self.run(SKAction.move(by: CGVector(dx: 0, dy: -5), duration: Constants.walkStepSpeed))
        }
        
        self.run(SKAction.moveTo(x: location.x, duration: Double(distance/300) * Constants.walkStepSpeed * 4)) {
            // After the movement is finished, remove the walkCycle action and call completion
            self.removeAction(forKey: "walkCycle")
            completion()
        }
        
        let waitAction = SKAction.wait(forDuration: Constants.walkStepSpeed)
        
        let walkCycle = SKAction.repeatForever(SKAction.sequence([step1, waitAction, step2, waitAction, step3, waitAction, step4, waitAction]))
        self.run(walkCycle, withKey: "walkCycle")
    }
    
}
