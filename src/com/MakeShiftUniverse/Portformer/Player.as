package com.MakeShiftUniverse.Portformer 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Player extends FlxSprite
	{
		//Sprite
		[Embed(source = '../../../../Art/sprPlayer.png')]public var sprPlayer:Class;
		
		//Sounds
		[Embed(source = '../../../../Sounds/Explosion.mp3')] public var sndDeath:Class;
		[Embed(source = '../../../../Sounds/Jump.mp3')]public var sndJump:Class;
		
		//TODO add more sounds
		
		//Variables
		protected var _jumpPower:int;
		protected var _bullets:FlxGroup;
		protected var _aim:uint;
		protected var _restart:Number;
		protected var _gibs:FlxEmitter;
		protected var onground:Boolean = false;
		protected var doublejump:Boolean;
		
		public function Player(x:int, y:int, Bullets:FlxGroup, Gibs:FlxEmitter)
		{
			super(x, y);
			loadGraphic(sprPlayer, true, true, 16);
			_restart = 0;
			
			//Hitbox
			width = 13;
			height = 16;
			offset.x = 1;
			offset.y = 0; //Keeping this here incase i change sprites
			
			//Physics!
			var runSpeed:uint = 80;
			drag.x = runSpeed * 8;
			acceleration.y = 200;
			_jumpPower = 200;
			maxVelocity.x = runSpeed;
			maxVelocity.y = _jumpPower;
			
			//animations
			addAnimation("idle", [0]);
			addAnimation("run", [1, 2],12);
			addAnimation("jump", [2]);
			//TODO
			/* Adding these for the future
			addAnimation("idle_up",[]);
			addAnimation("run_up[],12);
			addAnimation("jump_up"[]);
			addAnimation("jump_down"[]);
			*/
			
			//Shooting
			_bullets = Bullets;
			_gibs = Gibs;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			_bullets = null;
			_gibs = null;
		}
		
		override public function update():void 
		{
			if (!alive)
			{
				_restart += FlxG.elapsed;
				if (_restart < 2)
						FlxG.resetState();
				return;
			}
			
			// A landing sound
			if (justTouched(FLOOR) && (velocity.y > 50))
					//TODO add a sound
					FlxG.play(null);
					
			//movement
			acceleration.x = 0; //Stops if no direction is hold
			if (FlxG.keys.LEFT)
			{
				facing = LEFT;
				acceleration.x -= drag.x;
			}
			else if (FlxG.keys.RIGHT)
			{
				facing = RIGHT;
				acceleration.x += drag.x;
			}
			//Jumping
			onground = false;
			if (this.isTouching(FlxObject.FLOOR))
			{
				onground = true;
				doublejump = true;
			}
			if (FlxG.keys.justPressed("X"))
			{
				var jumped:Boolean = false;
				
				if (!onground)
				{
					if (doublejump)
					{
						FlxG.play(sndJump);
					}
				}
				if (onground)
				{
					FlxG.play(sndJump);
				}
				
				//normal jump
				if (onground)
				{
					velocity.y = -_jumpPower;
					jumped = true;
				}
				if (!onground && !jumped && doublejump)
				{
					velocity.y = -_jumpPower;
					doublejump = false;
				}
			}
			
			//aiming
			if (FlxG.keys.UP)
					_aim = UP;
			else if (FlxG.keys.DOWN && velocity.y)
					_aim = DOWN;
			else
					_aim = facing;
					
			//TODO
			//animation
			if (velocity.y != 0)
			{
				/* Add these when i have aiming animations
				if (_aim == UP) play("jump_up");
				else if (_aim == DOWN) play("jump_down");
				else play("jump");
				*/
				play("jump");
			}
			else if (velocity.x == 0)
			{
				/* Same as above
				if (_aim == UP) play("idle_up");
				else play("idle");
				*/
				
				play ("idle");
			}
			else 
			{
				/* Same as above
				if (_aim = UP) play("run_up");
				else play("run");
				*/
				play ("run");
			}
			
			//shooting
			if (FlxG.keys.justPressed("C"))
			{
				//TODO
				if (flickering)
						FlxG.play(null);
				if(FlxG.keys.justPressed("C"))
				{
					//TODO: add jam sound
					if(flickering)
							FlxG.play(null);
					else
					{
						//getMidpoint(_point);
						//(_bullets.recycle(Bullet) as Bullet).shoot(_point,_aim);
						//if(_aim == DOWN)
						//velocity.y -= 36;
					}
				}
			}
		}
		override public function hurt(Damage:Number):void 
		{
			Damage = 0;
			if (flickering)
				return;
			FlxG.play(null);
			flicker(1.3);
			if (FlxG.score > 1000) FlxG.score -= 1000;
			if (velocity.x > 0)
				velocity.x = -maxVelocity.x;
			else
				velocity.x = maxVelocity.x;
			super.hurt(Damage);
		}
		override public function kill():void 
		{
			if (!alive)
					return;
			solid = false;
			FlxG.play(sndDeath);
			//TODO
			/*
			 * FlxG.play(sndDeath2);
			 */
			super.kill();
			flicker(0);
			exists = true;
			visible = false;
			velocity.make();
			acceleration.make();
			FlxG.camera.shake(0.005, 0.35);
			FlxG.camera.flash(0xff76254B, 0.35);
			if (_gibs != null)
			{
				_gibs.at(this);
				_gibs.start(true, 5, 0, 50);
			}
		}
	}
}

