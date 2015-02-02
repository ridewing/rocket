//
//  BaseRocket.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-18.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import AVFoundation
import SpriteKit

class BaseRocket : NSObject {
	
	var size:CGSize				= CGSize(width: 60, height: 70);
	var sprite					= SKSpriteNode();
	let textures				= SKSpriteNode();
	var rocketSprite			= SKSpriteNode(imageNamed:"Rocket-Treehouse")
	let firePadding:CGFloat		= 30.0;
	lazy var canMove:Bool		= false;
	let playerBitmask:UInt32	= 0x1 << 0;
	let objectBitmask:UInt32	= 0x1 << 1;
	let fireSpriteNode			= SKSpriteNode();
	var fuel:CGFloat			= 100.0;
	var fuelTimer:NSTimer		= NSTimer();
	var worldScale:CGFloat		= 1.0;
	var turnRotation:CGFloat	= 0.06;
	
	override init()
	{
		
	}
	
	func addFireTrail()
	{
		fireSpriteNode.addChild(SKEmitterNode(fileNamed: "Fire"));
	}
	
	func build()
	{
		addFireTrail();
		
		fireSpriteNode.position.y = -40;
		fireSpriteNode.hidden = true;
		
		textures.addChild(fireSpriteNode);
		textures.addChild(rocketSprite);
		
		rocketSprite.zPosition = 100;
		fireSpriteNode.zPosition = 90;
		
		sprite.size = self.size;
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		
		sprite.position = CGPoint(x: screenSize.width*0.5, y:95);
		//sprite.color = SKColor.redColor();
		sprite.zPosition = 100;
		
		
		let body = SKPhysicsBody(rectangleOfSize: sprite.size);
		
		body.affectedByGravity = false;
		body.collisionBitMask	= playerBitmask;
		body.categoryBitMask	= playerBitmask;
		body.contactTestBitMask = playerBitmask;
		
		sprite.physicsBody = body;
		sprite.name = "player";
		
		sprite.addChild(textures);
		//textures.setScale(0.5);
	}
	
	func refuel(fuel:CGFloat)
	{
		self.fuel += fuel;

		if(self.fuel > 100)
		{
			self.fuel = 100;
		}
	}
	
	func emptyFuel() -> Bool
	{
		return (self.fuel < 1.0);
	}
	
	func lowFuel() -> Bool
	{
		return (self.fuel < 40.0);
	}
	
	func takeFuel()
	{
		self.fuel -= 1.0;
		//println("Fuel level: \(self.fuel)%");
		
		if(self.emptyFuel())
		{
			SKNode.delay(0.5)
			{
				self.toggleEngine(false);
			}
		}
	}
	
	func getSprite() -> SKSpriteNode
	{
		return self.sprite;
	}

	func idleAnimation()
	{
		let amplitudeX:CGFloat = 5;
		let amplitudeY:CGFloat = 2;
		var actionsArray:[SKAction] = [];
		
		let moveX = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
		let moveY = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
		let shakeAction = SKAction.moveByX(moveX, y: moveY, duration: 0.1);
		shakeAction.timingMode = SKActionTimingMode.EaseOut;
		actionsArray.append(shakeAction);
		actionsArray.append(shakeAction.reversedAction());
		
		let actionSeq = SKAction.sequence(actionsArray);
		textures.runAction(SKAction.repeatActionForever(actionSeq));
		
		//sound.play();
		
		fireSpriteNode.hidden = false;
	}
	
	func pickUp()
	{
		//bubbleSound.play()
		let stars = SKSpriteNode(fileNamed: "Stars");

		stars.zPosition = 200;
		textures.addChild(stars);
		
		SKNode.delay(1.0)
		{
			stars.removeFromParent();
		}
	}
	
	func explode()
	{
		let particle = SKSpriteNode(fileNamed: "Explosion");
		particle.zPosition = 101;
		textures.addChild(particle);
		SKNode.delay(0.1){
			self.rocketSprite.hidden = true;
		}

	}

	func stop()
	{
		toggleEngine(false);
		textures.removeAllActions();
		sprite.removeAllActions();
	}
	
	func kill()
	{
		let angle = CGFloat(M_PI*0.1);
		
		textures.runAction(SKAction.rotateToAngle(angle, duration: 1.0))
		
		SKNode.delay(0.3){
			self.sprite.runAction(SKAction.moveTo(CGPoint(x: self.sprite.position.x, y: -200.0), duration: 1.5)){
				self.stop();
			};
		}
	}
	
	func rotateLeft()
	{
		let anim = SKAction.rotateToAngle(-self.turnRotation, duration: 0.1);
		let fade = SKAction.fadeAlphaTo(0.4, duration: 0.1)
		textures.runAction(anim);
	}
	
	func rotateRight()
	{
		let anim = SKAction.rotateToAngle(self.turnRotation, duration: 0.1);
		let fade = SKAction.fadeAlphaTo(0.4, duration: 0.1)
		textures.runAction(anim);
	}
	
	func resetRotation()
	{
		let anim = SKAction.rotateToAngle(0.0, duration: 0.1);
		let fade = SKAction.fadeAlphaTo(0.0, duration: 0.1)
		textures.runAction(anim);
	}
	
	func move(pos:CGPoint)
	{
		self.sprite.position = pos;
	}
	
	func setPosition(pos:CGPoint)
	{
		self.sprite.position = pos;
	}
	
	func moveY(y:CGFloat, duration:Double = 0.1)
	{
		if(!canMove) {
			return;
		}
		
		let location	= CGPoint(x: sprite.position.x, y: y);
		let anim		= SKAction.moveTo(location, duration: duration);
		anim.timingMode = SKActionTimingMode.EaseInEaseOut;
		
		sprite.runAction(anim);
	}
	
	func toggleEngine(state:Bool)
	{
		fuelTimer.invalidate();
		
		if(state)
		{
			println("Turn on engine");
			canMove = true;
			idleAnimation();
			
			fuelTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "takeFuel", userInfo: nil, repeats: true);
		}
		else
		{
			canMove = false;
			println("Turn off engine");
			fireSpriteNode.hidden = true;
			fuelTimer.invalidate();
		}
	}
	
	func shake(duration:Float)
	{
		let amplitudeX:CGFloat = 2;
		let amplitudeY:CGFloat = 1.5;
		let numberOfShakes = duration / 0.04;
		var actionsArray:[SKAction] = [];
		for index in 1...Int(numberOfShakes) {
			// build a new random shake and add it to the list
			let moveX = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
			let moveY = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
			let shakeAction = SKAction.moveByX(moveX, y: moveY, duration: 0.02);
			shakeAction.timingMode = SKActionTimingMode.EaseOut;
			actionsArray.append(shakeAction);
			actionsArray.append(shakeAction.reversedAction());
		}
		
		let actionSeq = SKAction.sequence(actionsArray);
		textures.runAction(actionSeq);
	}
	
	func emitSmoke(position:CGPoint = CGPoint.zeroPoint) -> SKSpriteNode
	{
		let smoke = SKSpriteNode(fileNamed: "Smoke");
		smoke.position = position;
		smoke.zPosition = 89;
		
		return smoke;
	}
	
	private func random(max:CGFloat = 100.0) -> CGFloat
	{
		let rand = CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * max;
		return rand;
	}
}