//
//  MenuScene.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-27.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: BaseScene {
	
	let background	= SKSpriteNode(imageNamed: "Background");
	let logo		= SKSpriteNode(imageNamed: "Logo");
	
	override func didMoveToView(view: SKView)
	{
		background.position = CGPoint.zeroPoint;
		background.anchorPoint = CGPoint.zeroPoint;
		
		self.addChild(background);

		var base:CGFloat = self.size.height - 300.0;
		

		let buttonStartGame = self.createButton(
			"Start Game",
			position: CGPoint(x: self.size.width*0.5, y: base),
			action: "buttonStartGame"
		);
		
		let buttonSelectRocket = self.createButton(
			"Select Rocket",
			position: CGPoint(x: self.size.width*0.5, y: base - 70),
			action: "buttonSelectRocket"
		);
		logo.position.x = self.size.width*0.5;
		logo.position.y = self.size.height - 100;
		self.addChild(logo)
		
		self.addChild(buttonSelectRocket)
		self.addChild(buttonStartGame)
		
		self.animateClouds();
	}
	
	
	
	func buttonSelectRocket()
	{
		//GameData.Rocket = Objects.ROCKET_DEFAULT;
		loadRocketScene();
	}
	
	func buttonStartGame()
	{
		loadLevelSelect();
	}
	
	func loadRocketScene()
	{
		if let scene = RocketScene.unarchiveFromFile("RocketScene") as? SKScene {
			
			// Configure the view.
			let skView = self.view as SKView!
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
	
	func loadLevelSelect()
	{
		if let scene = LevelSelect.unarchiveFromFile("LevelSelect") as? SKScene {
			
			// Configure the view.
			let skView = self.view as SKView!
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
}