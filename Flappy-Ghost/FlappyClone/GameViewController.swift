//
//  GameViewController.swift
//  FlappyClone
//
//  Created by LEONARDO on 16/3/17.
//  Copyright (c) 2017 LEONARDO. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true

            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true

            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = self.view.bounds.size

            skView.presentScene(scene)
        }
    }
// En la clase que tiene la función viewDidLoad en la cual de ejecuta todo lo que se debe iniciar en la aplicación.
//
// Se crean la escena que está programada en el archivo GameScene, se muestra en la pantalla de la aplicación, además se configura para que se muestren el contador de nodos y los fotogramas por segundo en los que corre el juego, con fines de debug, pero estos se deben poner en false cuando la aplicación sea presentada a usuarios.


    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
