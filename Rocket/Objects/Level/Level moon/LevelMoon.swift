//
//  LevelMoon.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-22.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit;

class LevelMoon : Level {
	

	
	override init()
	{
		super.init();
		self.groundSprite		= SKSpriteNode(imageNamed: "GroundMoon")
		self.backgroundSprite	= SKSpriteNode(imageNamed: "BackgroundMoon")
		self.cloudsSprite		= SKSpriteNode()
	}
}