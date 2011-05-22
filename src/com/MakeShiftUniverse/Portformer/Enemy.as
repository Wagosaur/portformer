package com.MakeShiftUniverse.Portformer 
{
	import neoart.flectrum.Flectrum;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Wago
	 */
	public class Enemy extends FlxSprite
	{
		[Embed(source='../../../../Art/Bob.png')]public var player:Class;
		
		protected static const RUN_SPEED:int = 80;
		protected static const GRAVITY:int =420;
		protected static const JUMP_SPEED:int = 200;
		protected var _player:Player;

		public function Enemy(x:Number,y:Number,ThePlayer:Player)
		{
			super(x, y);
			
			loadGraphic(player, true, true, 32,32);
			addAnimation("walking", [0,1,2,3,4,5,6,7], 8, true);
			addAnimation("idle", [0]);
			_player = ThePlayer;
			
			drag.x = RUN_SPEED * 8;  // Drag is how quickly you slow down when you're not pushing a button. By using a multiplier, it will always scale to the run speed, even if we change it.
			drag.y = JUMP_SPEED * 7;
			acceleration.y = GRAVITY; // Always try to push helmutguy in the direction of gravity
            maxVelocity.x = RUN_SPEED;
            maxVelocity.y = JUMP_SPEED;
		}
		
		override public function update():void 
		{			
			acceleration.x = acceleration.y = 0; //stop when not chaasing player
			
			var xdistance:Number = _player.x - x; //distance on x axis to player
			var ydistance:Number = _player.y - y; //distance on y axis to player
			var distancesquared:Number = xdistance * xdistance + ydistance * ydistance; //
			if (distancesquared < 65000)
			{
				if (_player.x < x)
				{
				facing = RIGHT;
				acceleration.x = -drag.x;
				}
				else if (_player.x > x)
				{
				facing = LEFT;
				acceleration.x = drag.x;
				}
				if (_player.y < y)
				{
					acceleration.y = -drag.y;
				}
				else if (_player.y > y)
				{
					acceleration.y = drag.y;
				}
			}
			
			
			
			//animation
			if (!velocity.x && !velocity.y)
			{
				play("idle");
			}
			else 
			{
				play("walking");
			}
			super.update();
		}
		
	}

}