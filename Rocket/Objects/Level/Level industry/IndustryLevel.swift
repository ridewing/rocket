//
//  LevelIndustry.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-29.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit;

class IndustryLevel : Level {
	
	
	
	override init()
	{
		super.init();
		self.groundSprite		= SKSpriteNode(imageNamed: "Ground")
		self.backgroundSprite	= SKSpriteNode(imageNamed: "BackgroundIndustry")
		self.cloudsSprite		= SKSpriteNode()
	}
}