//
//  LevelIndustrySection.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-11-03.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import Foundation
import SpriteKit

class IndustryLevelSection : LevelSection {
	
	override func buildRow(type: NSString, atPosition position: CGPoint)
	{
		switch(type)
		{
			
		case RowType.CENTER:
			
			let saw = SawHorizontalCenter(side: Side.CENTER);
			saw.position.y = position.y;
			addChild( saw.getSprite() );
			
			self.createObjectRow( position.y );
			
		case RowType.DOUBLE:
			let saw = SawHorizontalSides(side: Side.CENTER);
			
			saw.position.y = position.y;
			
			addChild( saw.getSprite() );
			
			let star = BubbleItem(imageNamed: Objects.STAR, x : self.size.width*0.5, y : position.y);
			addChild( star.getSprite() );
		case RowType.STARS:
			createStarRow( position.y );
		default:
			println("Nothing on this row");
			
		}
	}
	
}