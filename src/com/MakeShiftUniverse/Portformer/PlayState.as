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
		[Embed(source='../../../../Art/Tileset.png')] public var levelTiles:Class;
		
		public var map:FlxTilemap = new FlxTilemap;
		public var background:FlxTilemap = new FlxTilemap;
		public var foreground:FlxTilemap = new FlxTilemap;
		
		public var player:Player;
		
		override public function create():void
		{
			add(background.loadMap(new levelMapBack, levelTiles, 16, 16));
			background.scrollFactor.x = background.scrollFactor.y = .5;
			
			add(map.loadMap(new levelMap, levelTiles, 16, 16 ));
			
			add(player = new Player(32, 16));
			
			add(foreground.loadMap(new levelMapFore, levelTiles, 16, 16));
			super.create();
		}
		
		override public function update():void 
		{
			super.update();
			FlxG.collide(player, map);
		}
	}
}