//
//  Rocket-Explorer.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-27.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit


class RocketExplorer : BaseRocket {
	
	override init()
	{
		super.init()
		worldScale		= 0.4;
		size			= CGSize(width: 60, height: 130);
		rocketSprite	= SKSpriteNode(imageNamed:"Rocket-Explorer");
		turnRotation	= 0.05;
	}
	
	override func addFireTrail() {

		let first	= SKEmitterNode(fileNamed: "Fire");
		let second	= SKEmitterNode(fileNamed: "Fire");
		let third	= SKEmitterNode(fileNamed: "Fire");
		let	fourth	= SKEmitterNode(fileNamed: "Fire");
		
		let particleHolder = SKSpriteNode();
		
		particleHolder.setScale(0.45);
		
		first.position.x = first.position.x - 30;
		second.position.x = second.position.x - 12;
		
		third.position.x = third.position.x + 12;
		fourth.position.x = fourth.position.x + 30;
		
		
		particleHolder.addChild(first);
		particleHolder.addChild(second);
		particleHolder.addChild(third);
		particleHolder.addChild(fourth);
		particleHolder.position.y = -35;
		
		self.fireSpriteNode.addChild(particleHolder);
	}
	
}