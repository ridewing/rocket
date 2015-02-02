//
//  Level01.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-11-03.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

struct LevelIndustry {
	
	class Level01 : IndustryLevelSection {
		
		override func loadLevel() {
			println("Loading Industry level 01")
			
			rows = [
				RowType.STARS,
				RowType.CENTER,
				RowType.DOUBLE,
				RowType.DOUBLE,
				RowType.CENTER,
				RowType.DOUBLE,
				RowType.STARS,
				RowType.CENTER,
				RowType.STARS,
				RowType.STARS,
				RowType.STARS,
				RowType.CENTER,
				RowType.STARS,
				RowType.CENTER
			];
		}
	}
}