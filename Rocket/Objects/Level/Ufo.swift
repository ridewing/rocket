//
//  Ufo.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-30.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class Ufo : LevelItem {
	
	let ufo = SKSpriteNode(imageNamed: "Ufo");
	
	override func build()
	{
		addChild(ufo);
	}
	
	override func startAnimate()
	{
		//blade.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(3.0, duration: 0.5)));
	}
	
	override func sensorBeginContact() {
		println("You just passed a ufo")
	}
}