//
//  GameViewController.swift
//  TileMap
//
//  Created by Matheus Silva on 12/10/19.
//  Copyright © 2019 Matheus Gois. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    let scene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let map = SKTextureAtlas(named: "Map")
        SKTextureAtlas.preloadTextureAtlases([map]) {
            print("tudo carregado")
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func scalePiece(_ gestureRecognizer : UIPinchGestureRecognizer) {   guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            let currentScale = scene.map.xScale
            var newScale = gestureRecognizer.scale
            if currentScale * gestureRecognizer.scale < 0.1 {
                newScale = 0.1 / currentScale
            } else if currentScale * gestureRecognizer.scale > 1 {
                newScale = 1 / currentScale
            }
            
            scene.map.setScale(newScale)
            print("current scale: \(currentScale), new scale: \(newScale)")
            
//            gestureRecognizer.scale = 1
        }
        
    }
    
}
