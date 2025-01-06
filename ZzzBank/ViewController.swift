//
//  ViewController.swift
//  ZzzBank
//
//  Created by 이인호 on 1/6/25.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let skView = SKView(frame: self.view.bounds)
        skView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(skView)
        
        let scene = GameScene()
        
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .systemBackground
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
    }
}

