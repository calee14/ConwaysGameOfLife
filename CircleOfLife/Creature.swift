//
//  Creature.swift
//  CircleOfLife
//
//  Created by Cappillen on 6/22/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit

class Creature: SKSpriteNode {
    
    //Character side
    var isAlive: Bool = false {
        didSet {
            //Visual of the creature
            isHidden = !isAlive
        }
    }
    
    var neighborCount = 0
    
    init() {
        //Initializer of the bubble asset
        let texture = SKTexture(imageNamed: "bubble")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        //Set the zPosition
        zPosition = 1
        
        
        //Set anchor point to the bottom left
        anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
