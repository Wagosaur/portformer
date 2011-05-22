package com.MakeShiftUniverse.Portformer 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Wago
	 */
	public class Player extends FlxSprite
	{
		[Embed(source = '../../../../Art/sprPlayer.png')]public var player:Class;
		
		//sounds
		[Embed(source = '../../../../Sounds/Explosion.mp3')] public var sndDeath:Class;
		[Embed(source = '../../../../Sounds/Jump.mp3')]public var sndJump:Class;
		
		protected static const RUN_SPEED:int = 80;
		protected static const GRAVITY:int =420;
		protected static const JUMP_SPEED:int = 200;
		
		public var onground:Boolean = false;
		
		public var doublejump:Boolean = false;
		public var dead:Boolean = false;
		
		protected var gibs:FlxEmitter;

		public function Player(x:int,y:int,Gibs:FlxEmitter):void
		{
			super(x, y);
			loadGraphic(player, true, true, 16,16);
			addAnimation("walking", [1, 2], 8, true);
			addAnimation("idle", [0]);
			
			drag.x = RUN_SPEED * 8;  // Drag is how quickly you slow down when you're not pushing a button. By using a multiplier, it will always scale to the run speed, even if we change it.
            acceleration.y = GRAVITY; // Always try to push helmutguy in the direction of gravity
            maxVelocity.x = RUN_SPEED;
            maxVelocity.y = JUMP_SPEED;
			gibs = Gibs;
		}
		
		override public function update():void 
		{			
			onground = false;
			if (this.isTouching(FlxObject.FLOOR))
			{
				onground = true;
				doublejump = true;
			}
			
			acceleration.x = 0; //Reset to 0 when no button is pushed
            
            if (FlxG.keys.LEFT)
            {
                facing = LEFT; 
                acceleration.x = -drag.x;
            }
            else if (FlxG.keys.RIGHT)
            {
                facing = RIGHT;
                acceleration.x = drag.x;                
            }
			if (FlxG.keys.justPressed("X"))
			{
				var jumped:Boolean = false;
				
				if (onground)
				{
					velocity.y = -JUMP_SPEED;
					jumped = true;
					FlxG.play(sndJump, 0.5, false);
				}
				
				if (!onground &&!jumped && doublejump)
				{
					velocity.y = -JUMP_SPEED;
					doublejump = false;
					FlxG.play(sndJump, 0.5, false);
					
				}
			}
			if (FlxG.keys.K)
			{
				this.kill();
				this.dead = true;
			}
			
			//if (FlxG.getPlugin(FlxControl) == null)
			//{
				//FlxG.addPlugin(new FlxControl);
			//}
			//FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			//FlxControl.player1.setCursorControl(false, false, true, true);
			//FlxControl.player1.setJumpButton("X", FlxControlHandler.KEYMODE_PRESSED, 200, FlxObject.FLOOR, 250, 200);
			//FlxControl.player1.setMovementSpeed(400, 0, 100, 200, 400, 0);
			//FlxControl.player1.setGravity(0, 400);	
			
			//animation
			if (velocity.x > 0 || velocity.x < 0)
			{
				play("walking");

			}
			else if (!velocity.x)
			{
				play("idle");
			}
			super.update();
		}
		override public function kill():void 
		{
			if (dead) { return; }
			
			super.kill();
			
			if (gibs != null)
			{
				FlxG.play(sndDeath, .5, false);
				gibs.at(this);
				gibs.start(true, 3 );
			}
		}
		
	}

}