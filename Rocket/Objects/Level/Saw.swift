//
//  Saw.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-28.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class Saw : LevelItem {
	
	let rack = SKSpriteNode(imageNamed: "Saw-rack");
	let blade = SKSpriteNode(imageNamed: "Saw-blade");
	
	override func build()
	{
		addChild(blade);
		addChild(rack);
		
		blade.position.x = blade.position.x - blade.size.width*0.5;
	}
	
	override func startAnimate()
	{
		blade.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(3.0, duration: 0.5)));
	}
	
	override func sensorBeginContact() {
		println("You just passed a saw")
	}
}