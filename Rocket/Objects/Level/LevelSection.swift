//
//  LevelSection.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-20.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

struct RowType {
	static var CENTER	= "center";
	static var DOUBLE	= "double";
	static var STARS	= "stars";
	static var EMPTY	= "empty";
}

class LevelSection {
	
	lazy var size:CGSize	= CGSize();
	lazy var scale:CGFloat  = 1.0;
	private let sprite				= SKSpriteNode();
	
	let rowHeight:CGFloat = 280.0;
	
	// Sides
	let sides:[NSString] = [];
	var lastSide:Int = 1;
	
	// Objects
	let objects:[NSString] = [];
	var lastObject:Int = 0;
	
	// Obstacles
	let obstacles:[NSString] = [];
	var lastObstacle:Int = 0;
	
	// Rows
	var rows:[NSString] = [];
	
	init()
	{
		// Sides
		sides.append(Side.LEFT);
		//sides.append(Side.CENTER);
		sides.append(Side.RIGHT);
	
		// Objects
		objects.append(Objects.RUBY);
		objects.append(Objects.FUEL);
		
		// Obstacles
		obstacles.append(Obstacles.SAW);
		obstacles.append(Obstacles.CRANE);
		
		self.loadLevel();
	}
	
	func loadLevelWithIndex(index:Int)
	{
		
	}
	
	func loadLevel()
	{
		
	}
	
	func setupWithSize(size:CGSize, scale:CGFloat = 1.0)
	{
		self.scale = scale;
		self.size = size;
		self.sprite.size = size;
		
		self.sprite.size.height = CGFloat(self.rows.count) * self.rowHeight;
		
		self.sprite.anchorPoint = CGPoint.zeroPoint;
		self.sprite.position	= CGPoint.zeroPoint;
		
		buildSection();
	}
	
	func setPosition(position:CGPoint)
	{
		self.sprite.position = position;
	}
	
	func getSprite() -> SKSpriteNode
	{
		return self.sprite;
	}
	
	func addChild(node:SKNode)
	{
		self.sprite.addChild(node);
	}
	
	func clear()
	{
		self.sprite.removeAllChildren();
	}
	
	func runing()
	{
	
	}
	
	func animate(duration:Double, closure:()->())
	{
		let animation = SKAction.moveToY(-sprite.size.height, duration: duration);
		sprite.runAction(animation)
		{
			closure();
		}
	}
	
	func buildRow(type:NSString, atPosition position:CGPoint)
	{
		
	}
	
	func createObjectRow(y:CGFloat)
	{
		lastObject = getRandomObject();
		
		let firstObject = BubbleItem(
			imageNamed: self.objects[lastObject],
			x : 15.0,
			y : y
		);
		
		self.sprite.addChild(firstObject.getSprite());
		
		var objInt = getRandomObject();
		
		while(objInt == lastObject)
		{
			objInt = getRandomObject();
		}
		
		lastObject = objInt;
		
		let secondObject = BubbleItem(
			imageNamed: self.objects[lastObject],
			x: self.size.width - 15.0,
			y: y
		);
		
		self.sprite.addChild(secondObject.getSprite());
	}
	
	func createStarRow(y:CGFloat)
	{
		var x:CGFloat = self.size.width/5;
		
		for i in 1...5
		{
			var starX = CGFloat(x) * CGFloat(i) - 40.0;
			
			let star = BubbleItem(imageNamed: Objects.STAR, x : starX, y : y + (self.rowHeight*0.5));
			self.sprite.addChild(star.getSprite());
		}
	}
	
	func getRandomObstacle() -> Int
	{
		var randomNumber : Int = Int(rand()) % (self.obstacles.count )
		var obstacle = self.obstacles[randomNumber];
		return randomNumber
	}
	
	func getRandomObject() -> Int
	{
		var randomNumber : Int = Int(rand()) % (self.objects.count )
		var object = self.objects[randomNumber];
		return randomNumber
	}
	
	func getRandomSide() -> Int
	{
		var randomNumber : Int = Int(rand()) % (self.sides.count )
		var side = self.sides[randomNumber];
		return randomNumber
	}
	
	func buildSection()
	{
		var index:Int = 0;
		
		println("Building section with rows: \(self.rows.count)");
		
		for type in self.rows
		{
			var position = CGPoint(x: 0.0, y: self.rowHeight*CGFloat(index));
			
			self.buildRow(type, atPosition: position);
			index++;
		}
	}
	
	deinit
	{
		println("Destroy section");
		self.sprite.removeAllChildren();
	}
}
