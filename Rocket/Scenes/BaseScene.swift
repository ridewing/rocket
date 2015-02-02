//
//  BaseScene.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-27.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

struct GlobalViewSettings {
	static var CloudPosition:CGPoint = CGPoint.zeroPoint;
}

class BaseScene: SKScene, SKPhysicsContactDelegate {
	
	var buttonSelectors:[String: Selector] = ["none":nil];
	var buttons:[String: SKNode] = ["none":SKNode()];
	let cloudsSprite = SKSpriteNode(imageNamed: "Clouds")
	var addedClouds:Bool = false;
	var currentButtonTouched:SKSpriteNode = SKSpriteNode();
	
	override func didMoveToView(view: SKView) {
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		self.size.width = screenSize.width;
		self.size.height = screenSize.height;
	}
	
	override func willMoveFromView(view: SKView)
	{
		GlobalViewSettings.CloudPosition.y = cloudsSprite.position.y;
		cloudsSprite.removeAllActions();
	}
	
	func createButton(text:NSString, position:CGPoint, action:Selector, fontsize:CGFloat = 32.0) -> SKSpriteNode
	{
		let button = SKSpriteNode();
		button.name = "button";
		button.zPosition = 100;
		button.position = position;
		
		let label = SKLabelNode(fontNamed: Fonts.MAIN);
		label.text = text;
		label.fontSize = fontsize;
		label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center;
		
		
		button.size = CGSize(width: label.frame.size.width+40, height: label.frame.size.height + 30);
		button.name = text;

		let background = SKSpriteNode();
		background.size = button.size;
		background.color = SKColor.blackColor();
		background.alpha = 0.6;
		background.name = "buttonBackground";
		
		let overlay = SKSpriteNode();
		overlay.size = button.size;
		overlay.name = "button-overlay";
		//overlay.anchorPoint = CGPoint.zeroPoint;
		//overlay.position = CGPoint.zeroPoint;
		
		button.addChild(background)
		button.addChild(label);
		button.addChild(overlay);
		
		self.buttonSelectors[text] = action;
		self.buttons[text] = button;
		
		return button;
	}
	
	func createButtonFromSprite(sprite:SKSpriteNode, action:Selector) -> SKSpriteNode
	{
		self.buttonSelectors[sprite.name!] = action;
		self.buttons[sprite.name!] = sprite;
		sprite.zPosition = sprite.zPosition + 100;
		return sprite;
	}
	
	func createBackButton(action:Selector) -> SKSpriteNode
	{
		let buttonBack = self.createButton(
			"Back",
			position: CGPoint(x: 50, y: self.size.height - 32),
			action: action,
			fontsize: 18
		);

		return buttonBack;
	}
	
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
	
		for touch: AnyObject in touches
		{
			let location = touch.locationInNode(self);
			let node		= (nodeAtPoint(location) as SKNode);
			
			if(node.isKindOfClass(SKSpriteNode))
			{
				if(node.name != nil)
				{
					if(node.name == "button-overlay")
					{
						let button = (node.parent as SKSpriteNode);
						
						if(button.childNodeWithName("buttonBackground") != nil)
						{
							let background = button.childNodeWithName("buttonBackground") as SKSpriteNode;
							background.alpha = 1.0;
						}
						
						self.currentButtonTouched = button;
						self.currentButtonTouched.runAction(SKAction.scaleTo(1.02, duration: 0.1));
					}
					else if(node.name != nil)
					{
						self.currentButtonTouched = (node as SKSpriteNode);
					}
				}
			}
			else
			{
				self.currentButtonTouched = SKSpriteNode();
			}
		}
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
	
		for touch: AnyObject in touches
		{
			let location = touch.locationInNode(self);
			let node		= (nodeAtPoint(location) as SKNode);
			
			if(node.isKindOfClass(SKSpriteNode))
			{
				if(node.name == "button-overlay")
				{
					let button = (node.parent as SKSpriteNode);
					let action:Selector = buttonSelectors[button.name!] as Selector!;
					
					NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: action, userInfo: nil, repeats: false);
				}
				else if(node.name != nil)
				{
					let action:Selector = buttonSelectors[node.name!] as Selector!;
					
					NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: action, userInfo: nil, repeats: false);
				}
			}
		}
		
		SKNode.delay(0.1)
		{
			let button = self.currentButtonTouched;
			if(button.childNodeWithName("buttonBackground") != nil)
			{
				let background = button.childNodeWithName("buttonBackground") as SKSpriteNode;
				background.alpha = 0.6;
				
				
				button.runAction(SKAction.scaleTo(1.0, duration: 0.1));
			}
		}
	}

	
	func animateClouds()
	{
		if(!self.addedClouds)
		{
			self.addedClouds = true;
			cloudsSprite.anchorPoint = CGPoint.zeroPoint;
			
			self.addChild(cloudsSprite);
		}
		
		self.cloudsSprite.position.y = GlobalViewSettings.CloudPosition.y;
		
		// Animate
		let cloudAnimation = SKAction.moveToY(-cloudsSprite.size.height, duration: 45.0);
		cloudsSprite.runAction(cloudAnimation)
		{
			GlobalViewSettings.CloudPosition.y = self.cloudsSprite.size.height;
			self.cloudsSprite.position.y = self.cloudsSprite.size.height;
			self.animateClouds();
		}
	}
	
	func MainMenu()
	{
		if let scene = MenuScene.unarchiveFromFile("MenuScene") as? SKScene {
			
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