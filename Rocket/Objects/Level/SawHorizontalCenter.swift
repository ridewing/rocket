//
//  SawHorizontalCenter.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-31.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class SawHorizontalCenter : LevelItem {
	
	// Rack
	let rack = SKSpriteNode(imageNamed: "Saw-horizontal-rack-middle");
	
	// Holder
	let holder = SKSpriteNode(imageNamed: "Saw-holder");
	
	// Blade
	let blade	= SKSpriteNode(imageNamed: "Saw-blade");
	
	// Saw
	let saw = SKSpriteNode();
	
	override func build()
	{
		createSaw();
		
		rack.addChild(saw);
		
		addChild(rack);
	}
	
	override func setupSpritePhysics() {
		let main = SKSpriteNode();
		main.name = "obstacle";
		main.size = CGSize(width: 184.0, height: 58.0);
		main.physicsBody = createPhysicsBody();
		//main.color = SKColor.blueColor();
		main.zPosition = 100;
		
		addChild(main);
	}
	
	func createSaw()
	{
		saw.addChild(blade);
		saw.addChild(holder);
		
		blade.position.y = -13;
		saw.position.x = (rack.size.width*0.5 - holder.size.width*0.5);
		saw.position.y = -53;
	}

	
	func animateSaw()
	{
		var move:[SKAction] = [];
		
		var minX:CGFloat = -55.0;
		var maxX:CGFloat = 55.0;
		
		var moveIn = SKAction.moveTo(CGPoint(x: maxX, y: saw.position.y), duration: 0.5);
		var moveOut = SKAction.moveTo(CGPoint(x: minX, y: saw.position.y), duration: 0.5);
		
		moveIn.timingMode = SKActionTimingMode.EaseInEaseOut;
		moveOut.timingMode = SKActionTimingMode.EaseInEaseOut;
		
		move.append(moveIn);
		move.append(moveOut);
		
		saw.runAction(SKAction.repeatActionForever(SKAction.sequence(move)));
		
		blade.runAction(
			SKAction.repeatActionForever(
				SKAction.rotateByAngle(-3.0, duration: 0.5)
			)
		);
	}
	
	override func startAnimate()
	{
		animateSaw();
	}
	
	override func sensorBeginContact() {
		println("You just passed a saw")
	}
}