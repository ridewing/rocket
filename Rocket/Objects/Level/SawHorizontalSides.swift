//
//  SawHorizontal.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-31.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class SawHorizontalSides : LevelItem {
	
	let fullWidth = true;
	
	// Rack
	let rack = SKSpriteNode(imageNamed: "Saw-horizontal-rack-sides");
	
	// Holder
	let holderLeft = SKSpriteNode(imageNamed: "Saw-holder");
	let holderRight = SKSpriteNode(imageNamed: "Saw-holder");
	
	// Blade
	let bladeLeft	= SKSpriteNode(imageNamed: "Saw-blade");
	let bladeRight	= SKSpriteNode(imageNamed: "Saw-blade");
	
	// Saw
	let sawLeft = SKSpriteNode();
	let sawRight = SKSpriteNode();
	
	override func build()
	{
		createLeftSaw();
		createRightSaw();
		
		rack.addChild(sawLeft);
		
		rack.addChild(sawRight);
		
		addChild(rack);
	}
	
	override func setupSpritePhysics() {
		let leftObj = SKSpriteNode();
		leftObj.name = "obstacle";
		leftObj.size = self.size;
		leftObj.physicsBody = createPhysicsBody();
		//leftObj.color = SKColor.blueColor();
		leftObj.zPosition = 100;
		leftObj.position.x = -self.size.width
		
		let rightObj = SKSpriteNode();
		rightObj.name = "obstacle";
		rightObj.size = self.size;
		rightObj.physicsBody = createPhysicsBody();
		//rightObj.color = SKColor.blueColor();
		rightObj.zPosition = 100;
		rightObj.position.x = self.size.width
		
		addChild(leftObj);
		addChild(rightObj);
	}
	
	func createRightSaw()
	{
		sawRight.addChild(bladeRight);
		sawRight.addChild(holderRight);
		
		bladeRight.position.y = -13;
		sawRight.position.x = (rack.size.width*0.5 - holderRight.size.width*0.5);
		sawRight.position.y = -55;
		sawRight.zPosition = 40;
	}
	
	func createLeftSaw()
	{
		sawLeft.addChild(bladeLeft);
		sawLeft.addChild(holderLeft);
		
		bladeLeft.position.y = -13;
		sawLeft.position.x = -(rack.size.width*0.5 - holderLeft.size.width*0.5);
		sawLeft.position.y = -55;
		sawLeft.zPosition = 40;
	}
	
	func animateRight()
	{
		var move:[SKAction] = [];
		
		var minX = (rack.size.width*0.5 - holderLeft.size.width*0.5);
		var maxX:CGFloat = 90;
		
		var moveIn = SKAction.moveTo(CGPoint(x: maxX, y: sawRight.position.y), duration: 0.5);
		var moveOut = SKAction.moveTo(CGPoint(x: minX, y: sawRight.position.y), duration: 0.5);
		
		moveIn.timingMode = SKActionTimingMode.EaseInEaseOut;
		moveOut.timingMode = SKActionTimingMode.EaseInEaseOut;
		
		move.append(moveIn);
		move.append(moveOut);
		
		sawRight.runAction(SKAction.repeatActionForever(SKAction.sequence(move)));
		
		bladeRight.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-3.0, duration: 0.5)));
	}
	
	func animateLeft()
	{
		var move:[SKAction] = [];
		
		var minX = -(rack.size.width*0.5 - holderLeft.size.width*0.5);
		var maxX:CGFloat = -90;
		
		var moveIn = SKAction.moveTo(CGPoint(x: maxX, y: sawLeft.position.y), duration: 0.5);
		var moveOut = SKAction.moveTo(CGPoint(x: minX, y: sawLeft.position.y), duration: 0.5);
		
		moveIn.timingMode = SKActionTimingMode.EaseInEaseOut;
		moveOut.timingMode = SKActionTimingMode.EaseInEaseOut;
		
		move.append(moveIn);
		move.append(moveOut);
		
		sawLeft.runAction(SKAction.repeatActionForever(SKAction.sequence(move)));
		
		bladeLeft.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(-3.0, duration: 0.5)));
	}
	
	override func startAnimate()
	{
		animateLeft();
		SKNode.delay(0.1)
		{
			self.animateRight();
		}
		

	}
	
	override func sensorBeginContact() {
		println("You just passed a saw")
	}
}