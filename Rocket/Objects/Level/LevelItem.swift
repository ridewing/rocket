//
//  LevelItem.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-30.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

struct Side {
	static var LEFT		= "Left";
	static var RIGHT	= "Right";
	static var CENTER	= "Center";
}

struct Obstacles {
	static var SAW		= "Saw";
	static var CRANE	= "Crane";
	static var UFO		= "Ufo";
}

class LevelItem {
	
	private var sprite:SKSpriteNode		= SKSpriteNode();
	private var sensor:SKSpriteNode		= SKSpriteNode();
	private var side					= Side.RIGHT;
	
	var size:CGSize {
		set {
			sprite.size = newValue;
		}
		get {
			return sprite.size;
		}
	}
	var position:CGPoint {
		set {
			sprite.position = newValue;
		}
		get {
			return sprite.position;
		}
	}
	
	init(side:NSString = Side.RIGHT)
	{
		// Set side
		self.side = side;
		
		// Setup sprite
		sprite.name			= "obstacle";
		sprite.size			= CGSize(width: 125, height: 125);
		//sprite.color		= SKColor.redColor()
		sprite.zPosition	= 100;
		
		// Creating custom body in center func
		setupSpritePhysics();
		
		// Sensor
		createSensor();
		
		// Handle diffents sides
		handleSide();
		
		// Initiate
		build();
		startAnimate()
	}
	
	func setupSpritePhysics()
	{
		sprite.physicsBody	= createPhysicsBody();

	}
	
	private func handleSide()
	{
		switch(self.side)
		{
		case Side.LEFT:
			left();
		case Side.CENTER:
			center();
		case Side.RIGHT:
			right();
		default:
			right();
		}
	}
	
	func left()
	{
		sprite.xScale = -1;
		position.x = size.width*0.5;
	}
	
	func right()
	{
		position.x = LevelSize.Width - size.width*0.5;
	}
	
	func center()
	{
		position.x = LevelSize.Width*0.5;
	}
	
	func build()
	{
		
	}
	
	func addChild(node:SKNode)
	{
		self.sprite.addChild(node);
	}
	
	func startAnimate()
	{
		
	}
	
	func createPhysicsBody() -> SKPhysicsBody
	{
		let physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size, center: sprite.position);
		
		physicsBody.affectedByGravity	= false;
		physicsBody.allowsRotation		= false;
		physicsBody.collisionBitMask	= Physics.objectBitmask;
		physicsBody.categoryBitMask		= Physics.objectBitmask;
		physicsBody.contactTestBitMask	= Physics.playerBitmask;
		
		return physicsBody;
	}
	
	func sensorBeginContact()
	{
		println("sensorBeginContact()");
	}
	
	private func createSensor()
	{
		sensor.name			= "obstacle-sensor";
		if(self.side == Side.RIGHT || self.side == Side.LEFT)
		{
			sensor.size.width	= LevelSize.Width - sprite.size.width;
			sensor.size.height	= sprite.size.height;
		}
		else
		{
			sensor.size.width	= LevelSize.Width;
			sensor.size.height	= sprite.size.height;
		}
		
		//sensor.color = SKColor.blueColor();
		sensor.zPosition = 40;
		
		let physicsBody = SKPhysicsBody(rectangleOfSize: sensor.size, center: sensor.position);
	
		physicsBody.affectedByGravity	= false;
		physicsBody.allowsRotation		= false;
		physicsBody.collisionBitMask	= Physics.sensorBitmask;
		physicsBody.categoryBitMask		= Physics.sensorBitmask;
		physicsBody.contactTestBitMask	= Physics.playerBitmask;
		
		sensor.physicsBody = physicsBody;
		
		if(self.side == Side.RIGHT || self.side == Side.LEFT)
		{
			sensor.position.x = -(sensor.size.width*0.5 + size.width*0.5);
		}
		else
		{
			//sensor.position.x = LevelSize.Width*0.5;
		}
		
		//self.physicsBody = physicsBody;
		addChild(sensor);
	}
	
	func getSprite() -> SKSpriteNode
	{
		return self.sprite;
	}
}