package com.MakeShiftUniverse.Portformer 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Wago
	 */
	public class Bullet extends FlxSprite
	{
		[Embed(source = '../../../../Art/sprBullet.png')] public var sprBuller:Class;
		
		public var dead:Boolean = false;
		
		public function Bullet() 
		{
			super();
			loadGraphic(sprBuller, true, true, 5, 5);
			exists = false;
		}
		
		override public function update():void 
		{
			if (dead && finished)
				exists = false;
			else
				super.update();
		}
		
		//Kill bullets on collision
		public function hitSide(constact:FlxObject, velocity:Number):void
		{
			kill();
		}
		public function hitBottom(constact:FlxObject, velocity:Number):void
		{
			kill();
		}
		public function hitTop(constact:FlxObject, velocity:Number):void
		{
			kill();
		}
		
		//shoot function
		public function shoot(x:int, y:int, VelocityX:int, VelocityY:int):void
		{
			super.reset(x, y);
			solid = true;
			velocity.x = VelocityX;
			velocity.y = VelocityY;
		}
		
	}

}