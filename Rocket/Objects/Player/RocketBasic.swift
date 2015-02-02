//
//  RocketBasic.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-27.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit


class RocketBasic : BaseRocket {
	
	override init()
	{
		super.init()
		rocketSprite	= SKSpriteNode(imageNamed:"Rocket-Basic");
	}
}