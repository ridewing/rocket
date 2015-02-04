//
//  GameScene.swift
//  Rocket
//
//  Created by Nicklas Ridewing on 2014-10-18.
//  Copyright (c) 2014 Nicklas Ridewing. All rights reserved.
//

import SpriteKit

struct Physics {
	static let playerBitmask:UInt32	= 0x1 << 0;
	static let objectBitmask:UInt32	= 0x1 << 1;
	static let sensorBitmask:UInt32 = 0x1 << 2;
}

class GameScene: BaseScene {
	
	lazy var player:BaseRocket	= BaseRocket();
	lazy var lvl:Level			= IndustryLevel();
	lazy var currentX:CGFloat	= 0.0;
	lazy var startX:CGFloat		= 0.0;
	lazy var running:Bool		= false;

	var score:Int = 0;
	var fuelCheck:NSTimer = NSTimer();
	
	let UILayer:UI = UI();
	
    override func didMoveToView(view: SKView)
	{
		// Determine what rocket to use
		switch(GameData.Rocket)
		{
			case Objects.ROCKET_BASIC:
				player = RocketBasic();
			case Objects.ROCKET_2000:
				player = Rocket2000();
			case Objects.ROCKET_EXPLORER:
				player = RocketExplorer();
			default:
				player = BaseRocket();
		}
		
		self.physicsWorld.contactDelegate = self;
		
		let screenSize: CGRect = UIScreen.mainScreen().bounds
		
		self.size.width = screenSize.width;
		self.size.height = screenSize.height;
		self.backgroundColor = SKColor.blackColor();
		
		UILayer.setSize(self.size);
		buildLevel();
		
		self.createButtonFromSprite(UILayer.getPausButton(), action: "pausButtonClicked");
	}
	
	func pausButtonClicked()
	{
		fuelCheck.invalidate();
		self.running = false;
		self.lvl.stop();
		self.player.stop();
		
		let overlay = SKSpriteNode();
		overlay.color = SKColor.blackColor();
		overlay.alpha = 0.8;
		overlay.zPosition = 2000;
		self.addChild(overlay);
		
		UILayer.hide();
	}
	
	func destroyLevel(closure:()->())
	{
		let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 1.0);
		self.runAction(fadeOut){
			self.removeAllChildren();
			closure();
		}
	}
	
	func buildLevel()
	{
		self.alpha = 0.0;
		let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 1.0);
		
		self.player.build();
		
		self.lvl.setup(CGSize(width: self.size.width, height: self.size.height), scale: self.player.worldScale);
		
		self.addChild(self.lvl.getBackground());
		
		self.addChild(self.player.getSprite());
		
		self.addChild(self.lvl.getForeground());
		
		self.addChild(self.lvl.getMiddle());
		
		self.addChild(UILayer.getSprite());
		
		self.runAction(fadeIn)
		{
			self.startupAnimation();
			
			self.fuelCheck = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "checkPlayerFuel", userInfo: nil, repeats: true);
		}
	}
	
	func blur()
	{
		let image:SKSpriteNode = SKSpriteNode(texture: SKTexture(image: self.getBlurredScreen()));
		image.zPosition = 2000;
		image.position = CGPoint.zeroPoint;
		image.anchorPoint = CGPoint.zeroPoint;
		
		self.addChild(image);
	}
	
	func checkPlayerFuel()
	{
		UILayer.setFuelLevel( self.player.fuel/100.0 );
		
		if(player.emptyFuel())
		{
			UILayer.warn(UIWarnings.WARNING_CLEAR);
			self.fuelCheck.invalidate();
			
			SKNode.delay(0.2){
				self.gameOver();
			}
		}
		else if(player.lowFuel())
		{
			UILayer.warn(UIWarnings.WARNING_LOW_FUEL);
		}
	}
	
	func startupAnimation()
	{
		self.player.shake(1.5);
		
		SKNode.delay(0.5)
		{
			let pos:CGPoint = CGPoint(x: self.lvl.groundSprite.position.x + self.lvl.groundSprite.size.width*0.5, y: self.lvl.groundSprite.position.y + 50);
			
			let smoke = self.player.emitSmoke(position: pos);
			self.lvl.addToGround(smoke);
		}
		
		SKNode.delay(1.0)
		{
			self.player.toggleEngine(true);
		}
		SKNode.delay(2.5)
		{
			self.player.moveY(self.player.sprite.position.y + 100, duration: 1.0);
			self.lvl.start();
			self.running = true;
		}
	}
	
	func gameOver()
	{
		if(running)
		{
			self.running = false;
			println("Game over");
			player.toggleEngine(false);
			SKNode.delay(0.1)
			{
				self.lvl.stop();
			}
			SKNode.delay(2.0)
			{
				self.goToMenu();
			}
		}
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		
		let bodyA = (contact.bodyA.node as SKSpriteNode);
		let bodyB = (contact.bodyB.node as SKSpriteNode);
		
		if(bodyA.name == "player")
		{
			if(bodyB.name == Objects.STAR)
			{
				bodyB.name = Objects.STAR_TAKEN;

				self.lvl.pickUp(bodyB);
				self.player.pickUp();
				self.pickUp();
			}
			else if(bodyB.name == Objects.FUEL)
			{
				self.lvl.pickUp(bodyB);
				self.player.pickUp();
				self.player.refuel(50.0);
				UILayer.warn(UIWarnings.NOTICE_REFUEL);
			}
			else if(bodyB.name == Objects.RUBY)
			{
				bodyB.name = Objects.RUBY_TAKEN;
				
				self.lvl.pickUp(bodyB);
				self.player.pickUp();
				self.pickUp(score: 1000);
			}
			else if(bodyB.name == "metorite")
			{
				self.player.explode();
				gameOver();
			}
			else if(bodyB.name == "obstacle")
			{
				self.player.explode();
				gameOver();
			}
			else if(bodyB.name == "LevelItem")
			{
				//let levelItem = (contact.bodyB.node as LevelItem);

				//levelItem.sensorBeginContact()
			}
			else
			{
				println("Collided with \(bodyB.name)");
			}
		}
		
		println("Body A name: \(bodyA.name)")
		println("Body B name: \(bodyB.name)")
	}
	
	func pickUp(score:Int = 10)
	{
		self.score += score;
		
		UILayer.addScore(score, startingPosition: self.player.getSprite().position)
		{
			self.UILayer.setScore(self.score);
		}
	}
	
	override func PlayerControllerActivated(direction: NSString) {
		if(player.canMove)
		{
			let old	= self.player.sprite.position;
			var x = old.x;
			
			if(direction == "right"){
				x += 10;
			} else {
				x -= 10;
			}
			
			self.player.move(CGPoint(x: x, y: old.y));
		}
	}

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
		super.touchesBegan(touches, withEvent: event);
		self.player.resetRotation();
    }
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event);
		self.player.resetRotation();
	}
	
	override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
		self.player.resetRotation();
	}
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent)
	{
		/*if(player.canMove)
		{
			var timer:NSTimer = NSTimer();
			
			for touch: AnyObject in touches
			{
				let location = touch.locationInNode(self);
				let previous = touch.previousLocationInNode(self);
				
				let translation = CGPoint(x: location.x - previous.x, y: location.y - previous.y);
				let old			= self.player.sprite.position;
				
				var x = old.x + translation.x;
				let offset = self.player.sprite.size.width*0.25;
				
				// Limit with walls
				if(x < offset) { x = offset; }
				if(x > self.size.width - offset) { x = self.size.width - offset; }
				
				if(abs(translation.x) > 5.0)
				{
					timer.invalidate();
					timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "slideStoped", userInfo: nil, repeats: false);
					
					if(location.x > previous.x)
					{
						self.player.rotateLeft();
					}
					else
					{
						self.player.rotateRight();
					}
				}
				
				self.player.move(CGPoint(x: x, y: old.y));
			}
		}*/
	}
	
	func slideStoped()
	{
		self.player.resetRotation();
	}
	
	func getBlurredScreen() -> UIImage
	{
		let view = self.view as SKView!;
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0);
		view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true);
		
		let ss:UIImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur");
		gaussianBlurFilter.setDefaults();
		gaussianBlurFilter.setValue(CIImage(image: ss), forKey: kCIInputImageKey);
		gaussianBlurFilter.setValue(5, forKey: kCIInputRadiusKey);

		let outputImage:CIImage = gaussianBlurFilter.outputImage;
		let context:CIContext = CIContext(options: nil);
		let rect = CGRect(origin: CGPoint.zeroPoint, size: self.size);
		
		let cgimg = context.createCGImage(outputImage, fromRect: rect);
		let image = UIImage(CGImage: cgimg);
		
		return image!;
	}
	
	private func goToMenu()
	{
		if let scene = MenuScene.unarchiveFromFile("MenuScene") as? SKScene {
			
			// Configure the view.
			let skView = self.view as SKView!
			skView.showsFPS = true
			skView.showsNodeCount = true
			skView.backgroundColor = SKColor.blackColor();
			
			/* Sprite Kit applies additional optimizations to improve rendering performance */
			skView.ignoresSiblingOrder = true
			
			/* Set the scale mode to scale to fit the window */
			scene.scaleMode = .AspectFill
			
			skView.presentScene(scene)
		}
	}
	
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
