//
//  BubbleItem.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-24.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class BubbleItem {
	
	// Base
	private let sprite = SKSpriteNode();
	private let bubble = SKSpriteNode(imageNamed: "Bubble");
	private var size:CGSize;
	
	// Image
	private var image:SKSpriteNode;
	private var imageNamed:String;
	
	init(imageNamed:String, x:CGFloat, y:CGFloat, size:CGSize = CGSize(width: 50, height: 50))
	{
		self.sprite.position = CGPoint(x: x, y: y);
		
		// Base setup
		self.size = size;
		
		// Setup image
		self.imageNamed = imageNamed;
		self.image		= SKSpriteNode(imageNamed: self.imageNamed);
		
		Build();
		HandleObjectTypes();
	}
	
	func getSprite() -> SKSpriteNode
	{
		return self.sprite;
	}
	
	private func Build()
	{
		// Set all sizes
		self.bubble.size	= self.size;
		self.image.size		= self.size;
		self.sprite.size	= self.size;
		
		let center = CGPoint(
			x: self.sprite.position.x + self.size.width*0.5,
			y: self.sprite.position.y + self.size.height*0.5
		)
		
		let physicsBody = SKPhysicsBody(rectangleOfSize: self.size);
		
		physicsBody.affectedByGravity	= false;
		physicsBody.collisionBitMask	= Physics.objectBitmask;
		physicsBody.categoryBitMask		= Physics.objectBitmask;
		physicsBody.contactTestBitMask	= Physics.playerBitmask;
		
		self.sprite.physicsBody = physicsBody;
		
		self.sprite.addChild(self.image);
		self.image.zPosition = 80;
		self.bubble.zPosition = 81;
		self.sprite.addChild(self.bubble);

		self.sprite.name = self.imageNamed;
	}
	
	private func HandleObjectTypes()
	{
		switch(self.imageNamed)
		{
			
		case Objects.FUEL:
			self.image.setScale(0.8);
			self.sprite.setScale(1.5);
		case Objects.RUBY:
			self.image.setScale(0.8);
			self.sprite.setScale(1.5);
		default:
			self.image.setScale(0.7);
			break;
			
		}
	}
}
