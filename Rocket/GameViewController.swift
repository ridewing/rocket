//
//  GameViewController.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-18.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            //var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
			var sceneData = NSData.dataWithContentsOfMappedFile(path) as NSData;
			var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData);
			
			
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
	
	class func delay(delay:Double, closure:()->()) {
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(delay * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(), closure)
	}
}

struct Levels {
	static var EARTH = "earth";
	static var INDUSTRY = "industry";
}

struct GameData {
	static var Rocket			= Objects.ROCKET_BASIC;
	static var Level			= Levels.INDUSTRY;
	static var LevelIndex:Int	= 1;
}

class GameViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        if let scene = MenuScene.unarchiveFromFile("MenuScene") as? SKScene {

			// Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
			skView.backgroundColor = SKColor.blackColor();
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
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
