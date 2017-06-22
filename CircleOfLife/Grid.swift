//
//  Grid.swift
//  CircleOfLife
//
//  Created by Cappillen on 6/22/17.
//  Copyright © 2017 Cappillen. All rights reserved.
//

import Foundation
import SpriteKit

class Grid: SKSpriteNode {
    
    //Grid Dimensions - x,y
    let rows = 8
    let columns = 10
    
    //Individual dimensions of the cell
    var cellWidth = 0
    var cellHeight = 0
    
    //Creature array
    var gridArray = [[Creature]]()
    
    var count = 0
    
    //Counter
    var population = 0
    var generation = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Called when a touch begins
        
        //There will only be one touch as for multi touch is disabled
        let touch = touches.first!
        let location = touch.location(in: self)
        
        //Calculate where the bubble is in the array using
        let gridX = Int(location.x) / cellWidth
        let gridY = Int(location.y) / cellHeight
        
        print(location)
        print(gridX)
        print(gridY)
        
        //Toggle the creature at the array index
        //gridArray[x][y] is an example of how to acces an object in a 2d array [x]-row [y]-collumn
        //Like chess go to x-5 to y- 10
        let creature = gridArray[gridX][gridY]
        creature.isAlive = !creature.isAlive
    }
    
    func addCreatureAtGrid(x: Int, y: Int) {
        //Add new creature at grid position
        
        //New Creature Object
        let creature = Creature()
        
        //Center the image in the center of the cell
        let newPosition = CGPoint(x: cellWidth*x + (cellWidth - Int(creature.size.width))/2, y: cellHeight*y + (cellHeight - Int(creature.size.width))/2)
        
        print("yello\(creature.size.width)")
        
        //let gridPosition = CGPoint(x: x*cellWidth, y: y*cellHeight)
        
        creature.position = newPosition
        
        //Set creature's life status
        creature.isAlive = false
        
        //Add creature to grid Node
        addChild(creature)
        
        //Add creature to grid Array
        //Takes the empty-row array initialized in the for loop for gridX
        gridArray[x].append(creature)
        
        
    }
    
    func populateGrid() {
        //Populate the grid with creatures
        
        //Loop through the columns
        for gridX in 0..<columns {
            
            //Intialize empty column 
            //The initialized column is acts as a row so when accessed we would use an x-value
            //And to access an item in the row we would the y-value - column :)
            gridArray.append([])
            
            //Loop through rows
            for gridY in 0..<rows {
                count += 1
                addCreatureAtGrid(x: gridX, y: gridY)
                print("Adding creature \(count)")
            }
        }
    }
    
    func countNeighbors() {
        //process arrays and update creature neighbor count
        
        //Loop through the columns 
        for gridX in 0..<columns {
            
            //Loop through rows
            for gridY in 0..<rows {
                
                //grab the current creature at grid position
                let currentCreature = gridArray[gridX][gridY]
                
                currentCreature.neighborCount = 0
                
                //Loop through all adjecent creatures to current creatures
                //Loop though the objects to the left and right of the current creature
                for innerGridX in (gridX - 1)...(gridX + 1) {
                    
                    //Ensure inner grid columns is inside the grid
                    if innerGridX < 0 || innerGridX >= columns { continue }
                    
                    //Loop through each object in the row
                    //searchs all the objects in the row above, below, and currently on for neighbors left and right.
                    for innerGridY in (gridY - 1)...(gridY + 1) {
                        
                        //Ensure the inner grid row is inside the grid
                        if innerGridY < 0 || innerGridY >= rows { continue }
                        
                        //Creature can't count itself as a neighbor 
                        if gridX == innerGridX && gridY == innerGridY { continue }
                        
                        //Grab reference of the adjacent creature
                        let adjacentCreature: Creature = gridArray[innerGridX][innerGridY]
                        
                        //Check if the neighbor is alive then add a neighbor
                        if adjacentCreature.isAlive {
                            currentCreature.neighborCount += 1
                        }
                    }
                }
            }
        }
    }
    
    func updateCreatures() {
        //process array and update creatures status
        
        //Reset the population
        population = 0
        
        //Loop through the collumns
        for gridX in 0..<columns {
            
            //Loop throught the rows
            for gridY in 0..<rows {
                
                //Grab reference of the creature at the point
                let currentCreature: Creature = gridArray[gridX][gridY]
                
                //Check the rules of th game 
                //3 neighbors - alive
                //1 or 0 - dead & 4-8 - dead
                switch currentCreature.neighborCount {
                    
                case 3:
                    currentCreature.isAlive = true
                    break;
                case 0...1, 4...8:
                    currentCreature.isAlive = false
                    break;
                default:
                    break;
                    
                }
                
                //Refresh the population count
                if currentCreature.isAlive { population += 1 }
            }
        }
    }
    
    func evolve() {
        //Update the grid to the next state in the game of life
        
        //Update the creatures neighbor count
        countNeighbors()
        
        //Calculate the living creatures
        updateCreatures()
        
        //Increment the generations
        generation += 1
    }
    
    //Required init for the sub class to work
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Enable touch for this node
        isUserInteractionEnabled = true
        
        //Calculate cell dimensions width and height
        cellWidth = Int(size.width) / columns
        cellHeight = Int(size.height) / rows
        
        populateGrid()
    }
}
