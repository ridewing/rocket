//
//  RocketScene.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-28.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class RocketScene: BaseScene {
	
	let background = SKSpriteNode(imageNamed: "Background");

	let rocketDefault	= SKSpriteNode(imageNamed: "Rocket-Treehouse");
	let rocketBasic		= SKSpriteNode(imageNamed: "Rocket-Basic");
	let rocket2000		= SKSpriteNode(imageNamed: "Rocket-2000");
	let rocketExplorer	= SKSpriteNode(imageNamed: "Rocket-Explorer");
	
	override func didMoveToView(view: SKView)
	{
		background.anchorPoint = CGPoint.zeroPoint;
		background.position = CGPoint.zeroPoint;
		
		self.addChild(background);
		
		let buttonBack = self.createBackButton("backButtonClick");
		
		self.addChild(buttonBack)
		
		self.rocketDefault.name = "Rocket-default-button";
		self.rocketBasic.name = "Rocket-basic-button";
		self.rocket2000.name = "Rocket-2000-button";
		self.rocketExplorer.name = "Rocket-explorer-button";
		
		self.createButtonFromSprite(self.rocketDefault, action: "pickRocketDefault");
		self.createButtonFromSprite(self.rocketBasic, action: "pickRocketBasic");
		self.createButtonFromSprite(self.rocket2000, action: "pickRocket2000");
		self.createButtonFromSprite(self.rocketExplorer, action: "pickRocketExplorer");
		
		rocketDefault.position = CGPoint(x: self.size.width*0.5 - 80, y: self.size.height*0.5 + 100);
		self.addChild(rocketDefault);

		rocketBasic.position = CGPoint(x: self.size.width*0.5 + 80, y: self.size.height*0.5 + 100);
		self.addChild(rocketBasic);
		
		rocket2000.position = CGPoint(x: self.size.width*0.5 - 80, y: self.size.height*0.5 - 100);
		self.addChild(rocket2000);
		
		rocketExplorer.position = CGPoint(x: self.size.width*0.5 + 80, y: self.size.height*0.5 - 100);
		self.addChild(rocketExplorer);
		
		self.animateClouds();
		markSelected(animated: false);
	}
	
	func markSelected(animated:Bool = true)
	{
		if(animated)
		{
			rocketDefault.runAction(SKAction.scaleTo(1.0, duration: 0.1));
			rocketBasic.runAction(SKAction.scaleTo(1.0, duration: 0.1));
			rocket2000.runAction(SKAction.scaleTo(1.0, duration: 0.1));
			rocketExplorer.runAction(SKAction.scaleTo(1.0, duration: 0.1));
		}

		var selected:SKSpriteNode = SKSpriteNode();
		
		switch(GameData.Rocket)
		{
			
		case Objects.ROCKET_DEFAULT:
			selected = rocketDefault;
		case Objects.ROCKET_BASIC:
			selected = rocketBasic;
		case Objects.ROCKET_2000:
			selected = rocket2000;
		case Objects.ROCKET_EXPLORER:
			selected = rocketExplorer;
		default:
			println("No rocket?");
		}
		
		if(animated)
		{
			selected.runAction(SKAction.scaleTo(1.1, duration: 0.2));
		}
		else
		{
			selected.setScale(1.1);
		}

	}
	
	func pickRocketDefault()
	{
		GameData.Rocket = Objects.ROCKET_DEFAULT;
		markSelected();
	}
	
	func pickRocketBasic()
	{
		GameData.Rocket = Objects.ROCKET_BASIC;
		markSelected();
	}
	
	func pickRocket2000()
	{
		GameData.Rocket = Objects.ROCKET_2000;
		markSelected();
	}
	
	func pickRocketExplorer()
	{
		GameData.Rocket = Objects.ROCKET_EXPLORER;
		markSelected();
	}
	
	func backButtonClick()
	{
		MainMenu();
	}
}