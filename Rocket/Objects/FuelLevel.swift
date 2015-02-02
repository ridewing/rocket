//
//  Progress.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-23.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class FuelLevel {

	let mask:SKSpriteNode = SKSpriteNode();
	let cropNode:SKCropNode = SKCropNode();
	let sprite:SKSpriteNode = SKSpriteNode();
	let particle:SKSpriteNode = SKSpriteNode(fileNamed: "FuelLevelParticles");
	var warning:Bool = false;
	
	init()
	{
		
		let background:SKSpriteNode = SKSpriteNode(imageNamed: "FuelLevelBackground");
		let overlay:SKSpriteNode = SKSpriteNode(imageNamed: "FuelLevelOverlay");
		
		let size:CGSize = CGSize(width: 375, height: 32);
		
		let mask = SKSpriteNode(color: SKColor.whiteColor(), size: size);
		mask.anchorPoint = CGPointMake(0.0, 0.5);
		mask.position = CGPoint(x: -mask.size.width*0.5, y: mask.position.y);
		
		cropNode.maskNode = mask;
		
		
		cropNode.addChild(background);
		cropNode.addChild(particle);
		sprite.addChild(cropNode);
		sprite.addChild(overlay);
		
		
		
		
		particle.position.y -= 10.0;
	}
	
	func warn()
	{
		if(!warning)
		{
			println("Warning: Low fuel");
			var animations:[SKAction] = [];

			animations.append(SKAction.scaleTo(1.02, duration: 0.2));
			animations.append(SKAction.scaleTo(1.0, duration: 0.2));
			
			sprite.runAction(SKAction.repeatActionForever(SKAction.sequence(animations)));
			warning = true;
		}
	}
	
	func notice()
	{
		clearWarn();
		var animations:[SKAction] = [];
		
		animations.append(SKAction.scaleTo(1.02, duration: 0.2));
		animations.append(SKAction.scaleTo(1.0, duration: 0.2));
		
		sprite.runAction(SKAction.sequence(animations));
	}
	
	func clearWarn()
	{
		warning = false;
		sprite.removeAllActions();
	}
	
	func setLevel(progress:CGFloat)
	{
		let node = (cropNode.maskNode as SKSpriteNode);
		
		node.runAction(SKAction.scaleXTo(progress, duration: 0.2));
	}
}
