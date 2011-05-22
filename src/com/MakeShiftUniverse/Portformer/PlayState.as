package com.MakeShiftUniverse.Portformer
{
	/*
	 * 
	 * ...
	 * @author
	 * Kristoffer 
	 * "Wago" 
	 * Kristoffersen 
	 * 
	 */
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
 
	public class PlayState extends FlxState
	{
		[Embed(source = '../../../../Maps/mapCSV_Group1_Map1.csv', mimeType = 'application/octet-stream')] public var levelMap:Class;
		[Embed(source = '../../../../Maps/mapCSV_Group1_Map1Back.csv', mimeType = 'application/octet-stream')] public var levelMapBack:Class;
		[Embed(source = '../../../../Maps/mapCSV_Group1_Map1Fore.csv', mimeType = 'application/octet-stream')] public var levelMapFore:Class;
		
		[Embed(source = '../../../../Art/Gibs.png')]public var sprGibs:Class;
		[Embed(source = '../../../../Art/Tileset.png')] public var levelTiles:Class;
		
		[Embed(source = '../../../../Sounds/JapaneseGirlsLoveFuton.mp3')] public var level1Music:Class;
		
		public var map:FlxTilemap = new FlxTilemap;
		public var background:FlxTilemap = new FlxTilemap;
		public var foreground:FlxTilemap = new FlxTilemap;
		public var bob:Enemy
		
		public var gibs:FlxEmitter;
		
		public var player:Player;
		
		override public function create():void
		{
			
			//set up gibs emitter
			gibs = new FlxEmitter();
			gibs.setXSpeed( -150, 150);
			gibs.setYSpeed( -200, 0);
			gibs.bounce = .5;
			gibs.gravity = 400;
			gibs.makeParticles(sprGibs, 50, 0, true, .5);
			
			add(background.loadMap(new levelMapBack, levelTiles, 16, 16));
			background.scrollFactor.x = background.scrollFactor.y = .5;
			
			add(map.loadMap(new levelMap, levelTiles, 16, 16 ));
			
			add(player = new Player(32, 16, gibs));
			
			add(bob = new Enemy(550, 432, player));
			
			add(foreground.loadMap(new levelMapFore, levelTiles, 16, 16));
			
			add(gibs);
			
			FlxG.playMusic(level1Music, .5);
			
			super.create();
		}
		
		override public function update():void 
		{
			super.update();
			FlxG.collide(player, map);
			FlxG.collide(bob, map);
			FlxG.collide(gibs, map);
			if (player.overlaps(bob))
			{
				player.kill();
				player.dead = true;
			}
			if (FlxG.keys.R)
			{
				FlxG.resetState();
			}
			if (FlxG.keys.M)
			{
			}
		}
	}
}