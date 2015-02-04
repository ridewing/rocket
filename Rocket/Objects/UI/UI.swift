//
//  UI.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-24.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

struct UIWarnings {
	static var WARNING_LOW_FUEL		= "WARNING_LOW_FUEL";
	static var NOTICE_REFUEL		= "WARNING_REFUEL";
	static var WARNING_CLEAR		= "WARNING_CLEAR";
}

struct Fonts {
	static var MAIN = "Comic Neue Angular Bold";
}

class UI {
	
	// Main
	private let sprite			= SKSpriteNode();
	private var size:CGSize		= CGSize.zeroSize;
	
	// Player controllers
	private let playerControllerLeft = SKSpriteNode();
	private let playerControllerRight = SKSpriteNode();
	
	// Fuel
	private let fuelLevel		= FuelLevel();

	// Score
	private let scoreLabel			= SKLabelNode(fontNamed: Fonts.MAIN);
	private let scoreLabelHolder	= SKSpriteNode();
	private let scoreIcon			= SKSpriteNode(imageNamed: "ObjectStar");
	
	// Paus
	private let pausButton			= SKSpriteNode(imageNamed: "PausButton");
	
	// Topbar
	private let topbarBackground = SKSpriteNode();
	
	init()
	{
		
	}
	
	func getSprite() -> SKSpriteNode
	{
		return self.sprite;
	}
	
	func getPausButton() -> SKSpriteNode
	{
		return self.pausButton;
	}
	
	func setSize(size:CGSize)
	{
		// Set sizes
		self.size = size;
		sprite.size = self.size;
		
		// Build the UI
		Build();
	}
	
	func hide()
	{
		sprite.hidden = true;
	}
	
	private func Build()
	{
		sprite.anchorPoint	= CGPoint.zeroPoint;
		sprite.position		= CGPoint.zeroPoint;
		sprite.zPosition	= 2000;
		
		scoreIcon.anchorPoint = CGPoint.zeroPoint;
		scoreIcon.size = CGSize(width: 35.0, height: 35.0);
		
		scoreIcon.position = CGPoint(
			x: scoreLabelHolder.position.x - scoreLabelHolder.frame.width - 40,
			y: self.size.height - scoreIcon.size.height - 5.0
		);
		
		fuelLevel.sprite.position = CGPoint(x: self.size.width*0.5, y : self.size.height-80);
		
		sprite.addChild(fuelLevel.sprite)

		sprite.addChild(TopBar())
		sprite.addChild(scoreIcon);
		sprite.addChild(ScoreLabel());
		sprite.addChild(PlayerController());
		setScore(0);
	}
	
	func warn(warning:String)
	{
		switch(warning)
		{
			
		case UIWarnings.WARNING_LOW_FUEL:
			fuelLevel.warn();
			
		case UIWarnings.NOTICE_REFUEL:
			fuelLevel.notice();
		
		default:
			break;
		}
	}
	
	func setFuelLevel(fuel:CGFloat)
	{
		self.fuelLevel.setLevel(fuel);
	}
	
	func addScore(value:Int, startingPosition:CGPoint, closure:()->())
	{
		let score = SKLabelNode(fontNamed: Fonts.MAIN);

		score.text		= "\(value)";
		score.position	= startingPosition;
		score.fontColor = SKColor.whiteColor();
		score.fontSize	= 25.0;
		
		sprite.addChild(score);
		
		let endPosition = scoreLabelHolder.position;
		let animation	= SKAction.moveTo(endPosition, duration: 0.5);
		
		score.runAction(animation)
		{
			score.removeFromParent();
				
			var scoreAnimations:[SKAction] = [];
				
			scoreAnimations.append(SKAction.scaleTo(1.2, duration: 0.05));
			scoreAnimations.append(SKAction.scaleTo(1.0, duration: 0.05));
				
			self.scoreLabelHolder.runAction(SKAction.sequence(scoreAnimations));
			closure();
		};
	}
	
	func setScore(score:Int)
	{
		// Update score label
		scoreLabel.text	= "\(score)";
		
		// Update holder to match the size
		scoreLabelHolder.size = scoreLabel.frame.size;
		
		// Move icon
		self.scoreIcon.position = CGPoint(
			x: self.scoreLabelHolder.position.x - self.scoreLabelHolder.frame.width - 40,
			y: self.scoreIcon.position.y
		);
	}
	
	func getScorePosition() -> CGPoint
	{
		return CGPoint(x: scoreLabelHolder.position.x - 20.0, y: scoreLabelHolder.position.y) ;
	}
	
	private func TopBar() -> SKSpriteNode
	{
		
		
		topbarBackground.alpha			= 0.4;
		topbarBackground.color			= SKColor.blackColor();
		topbarBackground.anchorPoint	= CGPoint.zeroPoint;
		topbarBackground.size			= CGSize(width: self.size.width, height: 50);
		topbarBackground.position		= CGPoint(x: 0, y: self.size.height - topbarBackground.size.height);
		
		pausButton.anchorPoint	= CGPoint.zeroPoint;
		pausButton.position		= topbarBackground.position;
		pausButton.name			= "ui-paus-button";
		pausButton.zPosition	= 2001;
		
		self.sprite.addChild(pausButton);
		
		return topbarBackground;
	}
	
	private func ScoreLabel() -> SKSpriteNode
	{
		scoreLabel.text						= "0";
		scoreLabel.fontColor				= SKColor.whiteColor();
		scoreLabel.fontSize					= 30.0;
		scoreLabel.horizontalAlignmentMode	= SKLabelHorizontalAlignmentMode.Right;
	
		scoreLabelHolder.size			= scoreLabel.frame.size;
		scoreLabelHolder.position		= CGPoint(x: self.size.width - 10, y: self.size.height - scoreLabel.frame.height - 12);
		scoreLabelHolder.anchorPoint	= CGPoint(x: 0.5, y: 0.5);
		
		scoreLabelHolder.addChild(scoreLabel);
		
		return scoreLabelHolder;
	}
	
	private func PlayerController() -> SKSpriteNode
	{
		let playerController = SKSpriteNode();
		
		let size = CGSize(width: self.sprite.size.width*0.5, height: self.sprite.size.height*0.5);
		
		playerControllerLeft.name = "player-controller-left";
		playerControllerRight.name = "player-controller-right";
		
		playerControllerLeft.size = size;
		playerControllerRight.size = size;
		
		//playerControllerLeft.color = UIColor.yellowColor();
		//playerControllerRight.color = UIColor.blueColor();
		
		playerControllerLeft.anchorPoint	= CGPoint.zeroPoint;
		playerControllerLeft.position		= CGPoint.zeroPoint;
		
		playerControllerRight.anchorPoint	= CGPoint.zeroPoint;
		playerControllerRight.position		= CGPoint(x: size.width, y: 0);
		
		playerController.size = CGSize(width: self.sprite.size.width, height: self.sprite.size.height*0.5);
		//playerController.color = UIColor.redColor();
		
		playerController.anchorPoint	= CGPoint.zeroPoint;
		playerController.position		= CGPoint.zeroPoint;
		
		playerController.addChild(playerControllerLeft);
		playerController.addChild(playerControllerRight);
		
		return playerController;
	}
	
}