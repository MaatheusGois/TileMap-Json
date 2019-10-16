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
    let tileSet = SKTileSet(named: "Map")!
    let tileSize = CGSize(width: 128, height: 128)
    var columns = 0
    var rows = 0
    var layer = SKTileMapNode()
    
    
    let cam = SKCameraNode()
    
    override func didMove(to view: SKView) {
        self.camera = cam
        setupMap()
    }
    
    func setupMap() {
        
        guard let mapJSON = MapHandler.loadMap() else { return }
        columns = mapJSON.getColumns()
        rows = mapJSON.getRows()
        
        addChild(map)
        
        map.xScale = 0.5
        map.yScale = 0.5
        
        let grass = tileSet.tileGroups.first { $0.name == "Grass" }
        let sand  = tileSet.tileGroups.first { $0.name == "Sand" }
        let water = tileSet.tileGroups.first { $0.name == "Water" }
        
        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottomLayer.fill(with: sand)
        map.addChild(bottomLayer)
        
        layer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        
        map.addChild(layer)
        
        for column in 0 ..< self.columns {
            for row in 0 ..< self.rows {
                switch mapJSON.map[column][row] {
                case MapCase.red.rawValue:
                    self.layer.setTileGroup(grass, forColumn: column, row: row)
                case MapCase.grey.rawValue:
                    self.layer.setTileGroup(sand, forColumn: column, row: row)
                default:
                    self.layer.setTileGroup(water, forColumn: column, row: row)
                    
                }
                
            }
        }
        
        
        self.giveTileMapPhysicsBody(map: self.layer)
        
    }
    
    func giveTileMapPhysicsBody(map: SKTileMapNode) {
        let tileMap = map
        
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        for column in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                
                if let tileDefinition = tileMap.tileDefinition(atColumn: column, row: row)
                    
                {
                    let isWaterTile = tileDefinition.userData?["AddBody"] as? Int
                    if (isWaterTile == 1) {
                        let tileArray = tileDefinition.textures
                        let tileTexture = tileArray[0]
                        let x = CGFloat(column) * tileSize.width - halfWidth + (tileSize.width/2)
                        let y = CGFloat(row) * tileSize.height - halfHeight + (tileSize.height/2)
                        let tileNode = SKNode()
                        tileNode.position = CGPoint(x: x, y: y)
                        tileNode.physicsBody = SKPhysicsBody(texture: tileTexture, alphaThreshold: 0.3, size: tileTexture.size())
                        tileNode.physicsBody?.isDynamic = false
                        
                        tileMap.addChild(tileNode)
                    }
                }
            }
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        
        map.position.x += location.x - previousLocation.x
        map.position.y += location.y - previousLocation.y
    }
    
}
