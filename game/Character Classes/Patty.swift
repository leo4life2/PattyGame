//
//  Patty.swift
//  game
//
//  Created by Leo Li on 2020/6/13.
//  Copyright © 2020 Leo Li. All rights reserved.
//

import SpriteKit

class Patty: Character {
    var hair: SKSpriteNode!
    
    public override func setupBodyParts() {
        super.setupBodyParts()
        
        self.hair = self.head.childNode(withName: "hair") as? SKSpriteNode
    }
}
