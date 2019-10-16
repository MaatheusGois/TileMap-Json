//
//  GameScene.swift
//  TileMap
//
//  Created by Matheus Silva on 12/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var map = CustomMap()
    
    override func didMove(to view: SKView) {
        map = CustomMap(namedTile: "Map", tileSize: CGSize(width: 128, height: 128))
        map.setScale(0.4)
        addChild(map)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        map.position.x += location.x - previousLocation.x
        map.position.y += location.y - previousLocation.y
    }
    
}
