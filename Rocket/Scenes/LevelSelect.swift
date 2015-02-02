//
//  LevelSelect.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-11-03.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class LevelSelect: BaseScene {

	let background = SKSpriteNode(imageNamed: "Background");
	
	override func didMoveToView(view: SKView)
	{
		super.didMoveToView(view);
		
		background.position = CGPoint.zeroPoint;
		background.anchorPoint = CGPoint.zeroPoint;
		
		self.addChild(background);
		
		let buttonBack = self.createBackButton("backButtonClick");
		
		self.addChild(buttonBack)
		
		setupLevels();
		
		self.animateClouds();
	}
	
	func setupLevels()
	{
		var top:CGFloat = self.size.height - 100.0;
		var y:CGFloat = 100.0;
		var index:Int = 0;
		var openLevels:Int = 8;
		var completedLevels:Int = 7;
		var sectionWidth = (self.size.width*0.8)/3;
		var paddingLeft = self.size.width*0.1;
		
		for row in 1...4
		{
			for col in 1...3
			{
				index++;
				
				if(index <= openLevels)
				{
					let icon = SKSpriteNode(imageNamed: "LevelIcon");
					icon.position.x = paddingLeft + (sectionWidth) * CGFloat(col) - sectionWidth*0.5;
					icon.position.y = top - y * CGFloat(row);
					
					let label = SKLabelNode(fontNamed: Fonts.MAIN);
					label.color = SKColor.whiteColor();
					label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
					label.fontSize = 28.0;
					//label.position.y = -7.0;
					
					if(index > 9)
					{
						label.text = "\(index)";
					}
					else
					{
						label.text = "0\(index)";
					}
					
					icon.addChild(label);
					
					if(index <= completedLevels)
					{
						let stars = SKSpriteNode(imageNamed: randomStars());
						stars.position.y = icon.size.height * 0.5 - stars.size.height*0.5 + 6.0;
						icon.addChild(stars);
					}
					
					icon.name = "level-\(index)";
					
					self.createButtonFromSprite(icon, action: "loadGameScene")
					
					self.addChild(icon);
				}
				else
				{
					let icon = SKSpriteNode(imageNamed: "LevelIconLocked");
					icon.position.x = paddingLeft + (sectionWidth) * CGFloat(col) - sectionWidth*0.5;
					icon.position.y = top - y * CGFloat(row);
					self.addChild(icon);
				}
			}
		}
	}
	
	func loadGameScene()
	{
		if let scene = GameScene.unarchiveFromFile("GameScene") as? SKScene {
			
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
	
	func backButtonClick()
	{
		MainMenu();
	}
	
	func randomStars() -> NSString
	{
		var images:[NSString] = ["LevelIconStars1", "LevelIconStars2", "LevelIconStars3"]
		
		var randomNumber : Int = Int(rand()) % (images.count )
		return images[randomNumber];
	}
}
