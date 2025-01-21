//
//  GameScene.swift
//  ZzzBank
//
//  Created by 이인호 on 1/6/25.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    private var viewModel: LoanViewModel
    
    init(viewModel: LoanViewModel, size: CGSize) {
        self.viewModel = viewModel
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {        
        var textureAtlas: SKTextureAtlas?
        var textureArray: [SKTexture] = []
        var timePerFrame: TimeInterval = 0.2
        
        switch viewModel.condition {
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
        let slime = SKSpriteNode(imageNamed: firstImage)
        
        slime.size = CGSize(width: 100, height: 100)
        slime.position = CGPoint(x: 75, y: 75)
        slime.name = "slime"
        
        let slimeAnimation = SKAction.animate(with: textureArray, timePerFrame: timePerFrame)
        slime.run(SKAction.repeatForever(slimeAnimation))
        
        self.addChild(slime)
    }
}
