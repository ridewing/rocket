//
//  Crane.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-29.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class Crane : LevelItem {
	
	private let craneBody	= SKSpriteNode(imageNamed: "CraneBody");
	private let craneBox	= SKSpriteNode(imageNamed: "CraneBox");
	
	override func build()
	{
		craneBox.anchorPoint.y	= 1.0;
		craneBox.position.y		= craneBox.size.height*0.5;
		craneBox.position.x		= -23.0;
		
		addChild(craneBox);
		addChild(craneBody);
	}
	
	override func startAnimate()
	{
		let rotationIn = SKAction.rotateToAngle(0.05, duration: 0.9);
		let rotationOut = SKAction.rotateToAngle(-0.05, duration: 0.9);
		
		rotationIn.timingMode = SKActionTimingMode.EaseInEaseOut
		rotationOut.timingMode = SKActionTimingMode.EaseInEaseOut;
		
		var animations:[SKAction] = [];
		
		animations.append(rotationIn);
		animations.append(rotationOut)
			
		craneBox.runAction(SKAction.repeatActionForever(SKAction.sequence(animations)));
	}
	
	override func sensorBeginContact() {
		println("There goes the crane")
	}
}