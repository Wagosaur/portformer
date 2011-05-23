package com.MakeShiftUniverse.Portformer
{
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
 
	public class PlayState extends FlxState
	{
		//Embeds
		[Embed(source = '../../../../Art/ranTiles.png')] protected var tileRand:Class;
		[Embed(source = '../../../../Art/ranDirt.png')] protected var tileDirt:Class;
		[Embed(source = '../../../../Sounds/JapaneseGirlsLoveFuton.mp3')]protected var sndBGMusic:Class;
		[Embed(source = '../../../../Art/Gibs.png')] protected var sprGibs:Class;
		
		//major object storing
		protected var _blocks:FlxGroup;
		protected var _decoration:FlxGroup;
		protected var _bullets:FlxGroup;
		protected var _player:Player;
		protected var _enemies:FlxGroup;
		protected var _spawners:FlxGroup;
		protected var _enemyBullets:FlxGroup;
		protected var _littleGibs:FlxEmitter;
		protected var _bigGibs:FlxEmitter;
		protected var _hud:FlxGroup;
		protected var _gunjam:FlxGroup;
		
		//Collision groups
		protected var _objects:FlxGroup;
		protected var _hazards:FlxGroup;
		
		//HUD stuff
		protected var _score:FlxText;
		protected var _score2:FlxText;
		protected var _scoretimer:Number;
		protected var _jamTimer:Number;
		
		//Fading
		protected var _fading:Boolean;
		
		override public function create():void 
		{
			FlxG.mouse.hide();
			
			//Here we limit gibs and recycle them
			_littleGibs = new FlxEmitter();
			_littleGibs.setXSpeed( -150, 150);
			_littleGibs.setYSpeed( -200, 0);
			_littleGibs.setRotation( -720, -720);
			_littleGibs.gravity = 350;
			_littleGibs.bounce = 0.5;
			_littleGibs.makeParticles(sprGibs, 50, 20, true, 0.5);
			
			//Here we create another limit on another st of gibs for bigger enemies
			_bigGibs = new FlxEmitter();
			_bigGibs.setXSpeed(-200,200);
			_bigGibs.setYSpeed( -300, 0);
			_bigGibs.setRotation( -720, -720);
			_bigGibs.gravity = 350;
			_bigGibs.bounce = 0.35;
			_bigGibs.makeParticles(sprGibs, 50, 20, true, 0.5);
			
			//Referance all other objects
			_blocks = new FlxGroup();
			_decoration = new FlxGroup();
			_enemies= new FlxGroup();
			_spawners = new FlxGroup();
			_enemyBullets = new FlxGroup();
			_hud = new FlxGroup();
			_bullets = new FlxGroup();
			
			//creat player object
			_player = new Player(316, 300, _bullets, _littleGibs);
			
			//Function to generat a level
			generateLevel();
			
			//Add enemies after blocks
			add(_spawners);
			add(_littleGibs);
			add(_bigGibs);
			add(_blocks);
			add(_decoration);
			add(_enemies);
			
			//Then add player
			add(_player);
			FlxG.camera.setBounds(0, 0, 1800, 1800,true);
			FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER);
			
			//add bullets last so they are on top of other crap
			add(_enemyBullets);
			add(_bullets);
			add(_hud);
			
			//Helper groups
			_hazards = new FlxGroup();
			_hazards.add(_enemyBullets);
			_hazards.add(_spawners);
			_hazards.add(_enemies);
			_objects = new FlxGroup();
			_objects.add(_enemyBullets);
			_objects.add(_spawners);
			_objects.add(_enemies);
			_objects.add(_player);
			_objects.add(_littleGibs);
			_objects.add(_bigGibs);
			
			//HUD
			_score = new FlxText(FlxG.width / 4, 0, FlxG.width / 2);
			_score.setFormat(null, 16, 0x008040, "center", 0x004040);
			_hud.add(_score);
			if (FlxG.scores.length < 2)
			{
				FlxG.scores.push(0);
				FlxG.scores.push(0);
			}
			
			if (FlxG.score > FlxG.scores[0])
					FlxG.scores[0] = FlxG.score;
			if (FlxG.scores[0] != 0)
			{
				_score2 = new FlxText(FlxG.width / 2, 0, FlxG.width / 2);
				_score2.setFormat(null, 8, 0x008040, "center", _score.shadow);
				_hud.add(_score2);
				_score2.text = "HIGHEST: " + FlxG.scores[0] + "\nLAST: " + FlxG.score;
			}
			FlxG.score = 0;
			_scoretimer = 0;
			
			_gunjam = new FlxGroup();
			_gunjam.add(new FlxSprite(0, FlxG.height -22).makeGraphic(FlxG.width, 24, 0xC0C0C0));
			_gunjam.add(new FlxText(0,FlxG.height-22,FlxG.width,"GUN IS JAMMED").setFormat(null,16,0xd8eba2,"center"));
			_gunjam.visible = false;
			_hud.add(_gunjam);
			
			_hud.setAll("scrollFactor", new FlxPoint(0, 0));
			_hud.setAll("cameras", [FlxG.camera]);
			
			//TODO:find better music
			FlxG.flash(0xff000000);
			_fading = false;
			
			FlxG.watch(_player, "X");
			FlxG.watch(_player, "Y");
			FlxG.watch(FlxG, "score");
			
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_blocks = null;
			_decoration = null;
			_bullets = null;
			_player = null;
			_enemies = null;
			_spawners = null;
			_enemyBullets = null;
			_littleGibs = null;
			_bigGibs = null;
			_hud = null;
			_gunjam = null;
			
			_objects = null;
			_hazards = null;
			
			_score = null;
			_score2 = null;
		}
		
		override public function update():void 
		{
			
			//save the current score
			var oldScore:uint = FlxG.score;
			super.update();
			
			//collisions
			FlxG.collide(_blocks, _objects);
			FlxG.overlap(_hazards, _player, overLapped);
			FlxG.overlap(_bullets, _hazards, overLapped);
			
			//Check if score have changed
			var scoreChanged:Boolean = oldScore != FlxG.score
			
			//Jammes message
			if (FlxG.keys.justPressed("C") && _player.flickering)
			{
				_jamTimer = 1;
				_gunjam.visible = true;
			}
			if (_jamTimer > 0)
			{
				if (!_player.flickering)
						_jamTimer = 0;
				if (_jamTimer < 0)
						_gunjam.visible = false;
			}
			
			if (!_fading)
			{
				//score and countdowns
				if (scoreChanged)
						_scoretimer = 2;
				_scoretimer -= FlxG.elapsed;
				if (_scoretimer < 0)
				{
					if (FlxG.score > 0)
					{
						if (FlxG.score > 100)
								FlxG.score -= 100;
						else
						{
							FlxG.score = 0;
							_player.kill();
						}
						_scoretimer = 1;
						scoreChanged = true;
						
						//Play beeps when your about to die
						var volume:Number = 0.35;
						if (FlxG.score < 600)
								volume = 1.0;
						FlxG.play(null, volume);
					}
				}
				
				//fade out to victory scree
				//win condition
				/*
				if (_spawners.countLiving() <= 0)
				{
					_fading = true;
					FlxG.fade(0xffd8eba2, 3, onVictory);
				}
				*/
			}
			
			//upodate score if changes
			if (scoreChanged)
			{
				if (!_player.alive) FlxG.score = 0;
				_score.text = FlxG.score.toString();
			}
		}
		
		protected function overLapped(sprite1:FlxSprite, sprite2:FlxSprite):void
		{
			if ((sprite1 is EnemyBullet) || (sprite1 is Bullet))
					sprite1.kill();
			sprite2.hurt(1);
		}
		
		protected function onVictory():void
		{
			FlxG.music.stop();
			FlxG.switchState(new VictoryState());
		}
		
		
		public function generateLevel():void 
		{
			var r:uint = 200;
			var b:FlxTileblock;
			
			//celing
			b = new FlxTileblock(0, 0, 1800, 16);
			b.loadTiles(tileRand);
			_blocks.add(b)
			
			//left wall
			b = new FlxTileblock(0,16,16,1800-16);
			b.loadTiles(tileRand);
			_blocks.add(b)
			
			//Right Wall
			b = new FlxTileblock(1800-16,16,16,1800-16);
			b.loadTiles(tileRand);
			_blocks.add(b)
			
			//Floor
			b = new FlxTileblock(16, 1000, 1000 - 32, 16);
			b.loadTiles(tileRand);
			_blocks.add(b)
			
			//Split the game world into a 4x4 grid
			buildRoom(r * 0, r * 0);
			buildRoom(r * 1, r * 0);
			buildRoom(r * 2, r * 0);
			buildRoom(r * 3, r * 0);
			buildRoom(r * 0, r * 1);
			buildRoom(r * 1, r * 1);
			buildRoom(r * 2, r * 1);
			buildRoom(r * 3, r * 1);
			buildRoom(r * 0, r * 2);
			buildRoom(r * 1, r * 2);
			buildRoom(r * 2, r * 2);
			buildRoom(r * 3, r * 2);
			buildRoom(r * 0, r * 3);
			buildRoom(r * 1, r * 3);
			buildRoom(r * 2, r * 3);
			buildRoom(r * 3, r * 3);
		}
		
		protected function buildRoom(RX:uint, RY:uint, Spawners:Boolean = false):void 
		{
			//Spawn points
			var rw:uint = 20;
			var sx:uint;
			var sy:uint;
			if (Spawners)
			{
				sx = 2 + FlxG.random() * (rw - 7);
				sy = 2 + FlxG.random() * (rw - 7);
			}
			
			//Then place a bunch of blocks
			var numBlocks:uint = 3 + FlxG.random() * 4;
			if (!Spawners) numBlocks ++;
			var maxW:uint = 10;
			var minW:uint = 2;
			var maxH:uint = 8;
			var minH:uint = 1;
			var bx:uint;
			var by:uint;
			var bw:uint;
			var bh:uint;
			var check:Boolean;
			for (var i:uint = 0; i < numBlocks; i++)
			{
				do
				{
					//Keep generatin different specs if they are overlaping
					bw = minW + FlxG.random() * (maxW - minW);
					bh = minH + FlxG.random() * (maxH - minH);
					bx = -1 + FlxG.random() * (rw + 1 - bw);
					by = -1 + FlxG.random() * (rw + 1 - bw);
					if (Spawners)
							check = ((sx > bx + bw) || (sx + 3 < bx) || (sy > by + bh) || (sy + 3 < by));
					else
						check = true;
				} while (!check);
				
				var b:FlxTileblock;
				b = new FlxTileblock(RX + bx * 8, RY + by * 8, bw * 8, bh * 8);
				b.loadTiles(tileRand);
				_blocks.add(b);
				
				//if the blocks have room, add some decoration
				/*
				if ((bw >= 4) && (bh >= 5))
				{
					b = new FlxTileblock(RX + bx * 8 + 8, RY + by * 8, bw * 8 - 16, 8);
					b.loadTiles(tileDirt);
					_decoration.add(b);
					
					b = new FlxTileblock(RX + bx * 8 + 8, RY + by * 8, bw * 8 - 16, bh * 8 - 24);
					b.loadTiles(tileDirt);
					_decoration.add(b);
				
				}
				*/
			}
			
			if (Spawners)
			{
				var sp:Spawner = new Spawner(RX+sx*8,RY+sy*8,_bigGibs,_enemies,_enemyBullets,_littleGibs,_player);
				_spawners.add(sp);
				
				//then create a dedicated camera to watch the spawner
				//TODO
				_hud.add(new FlxSprite(3 + (_spawners.length - 1) * 16, 3, null));
				var camera:FlxCamera = new FlxCamera(10 + (_spawners.length - 1) * 32, 10, 24, 24, 1);
				camera.follow(sp);
				FlxG.addCamera(camera);
			}
			
		}
	}
}