//
//  GameScene.swift
//  TileMap
//
//  Created by Matheus Silva on 12/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import SpriteKit
import GameplayKit

enum MapCase: Int {
    case red = 0
    case grey
    case brown
}

class GameScene: SKScene {
    
    let map = SKNode()
    let tileSet = SKTileSet(named: "mapTest")!
    let tileSize = CGSize(width: 128, height: 128)
    var columns = 0
    var rows = 0
    let cam = SKCameraNode()
    
    override func didMove(to view: SKView) {
        
        self.camera = cam
        
        guard let mapJSON = MapHandler.loadMap() else { return }
        columns = mapJSON.getColumns()
        rows = mapJSON.getRows()
        
        addChild(map)
        
        map.xScale = 0.5
        map.yScale = 0.5
        
        let redTile = tileSet.tileGroups.first { $0.name == "block_01" }
        let greyTile = tileSet.tileGroups.first { $0.name == "block_02"}
        let brownTile = tileSet.tileGroups.first { $0.name == "block_03"}
        
        let layer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        
        map.addChild(layer)
            
        for column in 0 ..< columns {
            for row in 0 ..< rows {
                switch mapJSON.map[column][row] {
                    case MapCase.red.rawValue:
                        layer.setTileGroup(redTile, forColumn: column, row: row)
                    case MapCase.grey.rawValue:
                        layer.setTileGroup(greyTile, forColumn: column, row: row)
                    default:
                        layer.setTileGroup(brownTile, forColumn: column, row: row)
                }
                
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)

        cam.position.x += location.x - previousLocation.x
        cam.position.y += location.y - previousLocation.y
    }
   
}
