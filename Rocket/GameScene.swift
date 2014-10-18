//
//  GameScene.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-18.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	lazy var hasRocket = false;
	let rocketSprite	= SKSpriteNode(imageNamed:"Rocket")
	let fireSprite		= SKSpriteNode(imageNamed: "Rocket-Fire")
	let groundSprite	= SKSpriteNode(imageNamed: "Ground")
	let backgroundSprite	= SKSpriteNode(imageNamed: "Background")
	let cloudsSprite	= SKSpriteNode(imageNamed: "Clouds")
	let padding:CGFloat = 10.0;
	
    override func didMoveToView(view: SKView)
	{
		
		backgroundSprite.setScale(1.25);
		backgroundSprite.position.x = self.size.width/2;
		backgroundSprite.position.y = self.size.height*0.5;
		
		cloudsSprite.setScale(1.25);
		cloudsSprite.position.x = self.size.width/2;
		cloudsSprite.position.y = self.size.height*0.5;
		
		groundSprite.setScale(0.75);
		groundSprite.position.x = self.size.width/2;
		groundSprite.position.y = groundSprite.size.height * 0.5;
		

		addChild(backgroundSprite);

		addChild(groundSprite);
		
		
		createRocket(CGPoint(x: self.size.width/2, y: groundSprite.size.height - 10.0));
		addChild(cloudsSprite);
		startupAnimation();

    }
	
	func startupAnimation()
	{
		let clouds = SKAction.moveToY(self.groundSprite.position.y - 100, duration: 1.0);
		
		shake(1.5);
		delay(2.0){
			self.toggleEngine(true);
		}
		delay(2.5)
		{
			self.updateRocket(CGPoint(x: self.rocketSprite.position.x, y: self.rocketSprite.position.y + 100), duration: 1.0)
			
			let groundSink = SKAction.moveToY(self.groundSprite.position.y - 200, duration: 1.0);
			self.groundSprite.runAction(groundSink);
			self.cloudsSprite.runAction(clouds);
		}
	}
	
	func shake(duration:Float) {
		let amplitudeX:CGFloat = 4;
		let amplitudeY:CGFloat = 3;
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
		rocketSprite.runAction(actionSeq);
		fireSprite.runAction(actionSeq);
	}
	
	func rotateLeft()
	{
		let leftAnimation = SKAction.rotateToAngle(0.02, duration: 0.2);
		self.rocketSprite.runAction(leftAnimation);
	}
	
	func rotateRight()
	{
		let rightAnimation = SKAction.rotateToAngle(-0.02, duration: 0.2);
		self.rocketSprite.runAction(rightAnimation);
	}
	
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches
		{
			let location = touch.locationInNode(self)
			toggleEngine(true);
			updateRocket(CGPoint(x: location.x, y: rocketSprite.position.y))
        }
    }
	
	func delay(delay:Double, closure:()->()) {
		dispatch_after(
			dispatch_time(
				DISPATCH_TIME_NOW,
				Int64(delay * Double(NSEC_PER_SEC))
			),
			dispatch_get_main_queue(), closure)
	}
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		toggleEngine(false);
	}
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
	{
		for touch: AnyObject in touches
		{
			let location = touch.locationInNode(self)
			updateRocket(CGPoint(x: location.x, y: rocketSprite.position.y))
		}
	}
	
	func createRocket(location: CGPoint)
	{
		hasRocket = true;
		rocketSprite.xScale	= 0.5
		rocketSprite.yScale	= 0.5
		rocketSprite.position = location
		
		fireSprite.xScale	= 0.5
		fireSprite.yScale	= 0.5
		fireSprite.position = CGPoint(x: location.x, y: location.y - (fireSprite.size.height - padding));
		
		self.addChild(fireSprite);
		self.addChild(rocketSprite)
		
		fireSprite.alpha = 0.0;
	}
	
	func updateRocket(location:CGPoint, duration:Double = 0.1)
	{
		
		let anim = SKAction.moveTo(location, duration: duration);
		let fireAnim = SKAction.moveTo(
			CGPoint(x: location.x, y: location.y - (fireSprite.size.height - padding)),
			duration: duration
		)
		
		rocketSprite.runAction(anim);
		fireSprite.runAction(fireAnim);
	}
	
	func toggleEngine(state:Bool)
	{
		if(state)
		{
			let action = SKAction.fadeInWithDuration(0.5);
			fireSprite.runAction(action);
		}
		else
		{
			let action = SKAction.fadeOutWithDuration(0.1);
			fireSprite.runAction(action);
		}
	}
	
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
