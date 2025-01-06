//
//  GameScene.swift
//  ZzzBank
//
//  Created by 이인호 on 1/6/25.
//

import Foundation
import SpriteKit

enum Condition {
    case healthy
    case tired
    case exhausted
    case unwell
}

class GameScene: SKScene {
    private var condition: Condition = .healthy
    
    override func didMove(to view: SKView) {        
        var textureAtlas: SKTextureAtlas?
        var textureArray: [SKTexture] = []
        var timePerFrame: TimeInterval = 0.2
        
        switch condition {
        case .healthy:
            textureAtlas = SKTextureAtlas(named: "healthy")
            break
        case .tired:
            textureAtlas = SKTextureAtlas(named: "tired")
            break
        case .exhausted:
            textureAtlas = SKTextureAtlas(named: "exhausted")
            timePerFrame = 0.1
            break
        case .unwell:
            break
        }
        
        guard let textureAtlas else { return }
        
        for i in 0..<textureAtlas.textureNames.count {
            let name = "\(textureAtlas.textureNames[i])"
            textureArray.append(SKTexture(imageNamed: name))
        }
        
        let firstImage = textureAtlas.textureNames.first!
        var slime = SKSpriteNode(imageNamed: firstImage)
        
        slime.size = CGSize(width: 100, height: 100)
        slime.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        slime.name = "slime"
        
        let slimeAnimation = SKAction.animate(with: textureArray, timePerFrame: timePerFrame)
        slime.run(SKAction.repeatForever(slimeAnimation))
        
        self.addChild(slime)
    }
}
