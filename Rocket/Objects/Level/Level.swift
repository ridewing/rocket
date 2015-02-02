//
//  Level.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-19.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

struct LevelSize {
	static var Width:CGFloat = 0.0;
	static var Height:CGFloat = 0.0;
}

class Level {
	
	lazy var size:CGSize = CGSize.zeroSize;
	lazy var scale:CGFloat = 1.0;
	lazy var animateClouds:Bool = true;
	
	lazy var groundSprite		= SKSpriteNode(imageNamed: "Ground")
	lazy var backgroundSprite	= SKSpriteNode(imageNamed: "Background")
	lazy var cloudsSprite		= SKSpriteNode(imageNamed: "Clouds")
	lazy var launchpadSprite	= SKSpriteNode(imageNamed: "LaunchPad")
	
	let background	= SKSpriteNode();
	let foreground	= SKSpriteNode();
	var section		= IndustryLevelSection();
	
	let speed:Double = 0.40;
	
	init()
	{
		background.zPosition = 10;
		section.getSprite().zPosition = 20;
		foreground.zPosition = 200;
		self.loadLevelWithIndex(GameData.LevelIndex);
	}
	
	func loadLevelWithIndex(index:Int)
	{
		self.section = LevelIndustry.Level01();
	}
	
	func getBackground() -> SKSpriteNode
	{
		return self.background;
	}
	
	func getForeground() -> SKSpriteNode
	{
		return self.foreground;
	}
	
	func getMiddle() -> SKSpriteNode
	{
		return self.section.getSprite();
	}
	
	func setSize(size:CGSize)
	{
		LevelSize.Height	= size.height;
		LevelSize.Width		= size.width;
		self.size = size;
	}

	func setScale(scale:CGFloat)
	{
		self.scale = scale;
	}
	
	func setup(size:CGSize, scale:CGFloat = 1.0)
	{
		setSize(size);
		setScale(scale);
		
		setupBackground();
		setupMiddle();
		setupForeground();
	}
	
	func addToGround(node:SKSpriteNode)
	{
		self.groundSprite.addChild(node);
	}
	
	private func setupMiddle()
	{
		section.clear();
		
		let size:CGSize = CGSize(width: self.size.width, height: self.size.height);
		section.setupWithSize(size, scale: self.scale);
		section.setPosition(CGPoint(x: 0, y: self.size.height + 100.0));
	}
	
	private func setupForeground()
	{
		// Level Clouds
		cloudsSprite.anchorPoint	= CGPoint.zeroPoint;
		cloudsSprite.position		= CGPoint.zeroPoint;
		cloudsSprite.zPosition		= 110;
		
		// Level Foreground
		foreground.size = CGSize(width: size.width, height: cloudsSprite.size.height);
		foreground.anchorPoint	= CGPoint.zeroPoint;
		foreground.position		= CGPoint.zeroPoint;
		
		foreground.addChild(cloudsSprite);
		
		foreground.position.y = foreground.size.height;
	}
	
	func pickUp(pickUp:SKSpriteNode)
	{
		var animation:[SKAction] = [];
		
		//animation.append( SKAction.moveTo(CGPoint(x: self.size.width, y: self.size.height), duration: 0.5) );
		animation.append( SKAction.scaleTo(0.0, duration: 0.2) );
		
		let sequence = SKAction.sequence(animation);
		
		pickUp.runAction(sequence){
			pickUp.removeFromParent();
		}
	}
	
	private func setupBackground()
	{
		// Main background
		backgroundSprite.anchorPoint	= CGPoint.zeroPoint;
		backgroundSprite.position		= CGPoint.zeroPoint;
		
		// Level Ground
		groundSprite.anchorPoint = CGPoint.zeroPoint;
		groundSprite.position = CGPoint.zeroPoint;
		
		background.addChild(backgroundSprite);
		background.addChild(groundSprite);
		
		launchpadSprite.anchorPoint = CGPoint.zeroPoint;
		launchpadSprite.position	= CGPoint(x: groundSprite.size.width*0.5 - launchpadSprite.size.width*0.5 - 20.0, y: groundSprite.size.height);
		
		groundSprite.addChild(launchpadSprite);
	}
	
	func start()
	{
		self.animateClouds = true;
		
		hideGround();
		
		self.animateForeground();
		
		SKNode.delay(2.0)
		{
			self.animateMiddle();
		}

		
		let backgroundAnimation = SKAction.moveToY(-(self.backgroundSprite.size.height - self.size.height), duration: 60.0);
		self.backgroundSprite.runAction(backgroundAnimation);
	}
	
	func fadeClouds()
	{
		let fadeOut = SKAction.fadeOutWithDuration(10.0);
		self.cloudsSprite.runAction(fadeOut){
			self.animateClouds = false;
		}
	}
	
	func hideGround()
	{
		let groundSink = SKAction.moveToY(self.groundSprite.position.y - 400, duration: 2.0);
		self.groundSprite.runAction(groundSink){
		
			self.groundSprite.removeAllChildren();
			self.launchpadSprite.removeFromParent();
		};
	}
	
	func showGround()
	{
		let groundSink = SKAction.moveToY(groundSprite.size.height * 0.5, duration: 0.1);
		self.groundSprite.runAction(groundSink);
	}
	
	func animateForeground()
	{
		if(self.animateClouds)
		{
			// Reset position
			foreground.position.y = foreground.size.height;
			
			// Animate
			let foregroundAnimation = SKAction.moveToY(-foreground.size.height, duration: 5.0*speed);
			foreground.runAction(foregroundAnimation)
			{
				self.animateForeground();
			}
		}
	}
	
	func animateMiddle()
	{
		let duration = Double(1.5 * CGFloat(section.rows.count) * CGFloat(speed));
		
		section.runing();
		section.animate(duration)
		{
			self.setupMiddle();
			self.animateMiddle();
		}
	}
	
	func stop()
	{
		foreground.removeAllActions();
		background.removeAllActions();
		backgroundSprite.removeAllActions();
		section.getSprite().removeAllActions();
	}
	
	deinit
	{
		self.background.removeAllChildren();
		self.foreground.removeAllChildren();
		section.getSprite().removeAllChildren();
	}
}