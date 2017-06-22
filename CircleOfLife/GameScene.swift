//
//  GameScene.swift
//  CircleOfLife
//
//  Created by Cappillen on 6/22/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //UI objects
    var stepButton: MSButtonNode!
    var populationLabel: SKLabelNode!
    var generationLabel: SKLabelNode!
    var playButton: MSButtonNode!
    var pauseButton: MSButtonNode!
    
    //Game objects
    var gridNode: Grid!
    
    override func didMove(to view: SKView) {
        //Set up scene here
        
        //Connect UI scene objects
        stepButton = self.childNode(withName: "stepButton") as! MSButtonNode
        populationLabel = self.childNode(withName: "populationLabel") as! SKLabelNode
        generationLabel = self.childNode(withName: "generationLabel") as! SKLabelNode
        playButton = self.childNode(withName: "playButton") as! MSButtonNode
        pauseButton = self.childNode(withName: "pauseButton") as! MSButtonNode
        
        gridNode = childNode(withName: "gridNode") as! Grid
        
        stepButton.selectedHandler = {
            self.stepSimulation()
        }
        
        //Create and action based timer for our play button
        let delay = SKAction.wait(forDuration: 0.5)
        
        //Call the stepSimulation to advance the simulation 
        let callMethod = SKAction.perform(#selector(stepSimulation), onTarget: self)
        
        //Create the functionality
        let stepSequence = SKAction.sequence([delay, callMethod])
        
        let simulation = SKAction.repeatForever(stepSequence)
        
        self.run(simulation)
        
        self.isPaused = true
        
        playButton.selectedHandler = { [unowned self] in
            self.isPaused = false
        }
        
        pauseButton.selectedHandler = { [unowned self] in
            self.isPaused = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Called when a touch begins
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func stepSimulation() {
        //Step simulation
        
        //Run the next step in simulaiton
        gridNode.evolve()
        
        //Update UI labels
        populationLabel.text = String(gridNode.population)
        generationLabel.text = String(gridNode.generation)
    }
}
