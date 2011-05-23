package com.MakeShiftUniverse.Portformer 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Wago
	 */
	public class Spawner extends FlxSprite
	{
		
		private var _timer:Number;
		private var _bots:FlxGroup;
		private var _botBullets:FlxGroup;
		private var _botGibs:FlxEmitter;
		private var _gibs:FlxEmitter;
		private var _player:Player;
		private var _open:Boolean;
		
		public function Spawner(X:int, Y:int,Gibs:FlxEmitter,Bots:FlxGroup,BotBullets:FlxGroup,BotGibs:FlxEmitter,ThePlayer:Player)
		{
			super(X,Y);
			loadGraphic(null,true);
			_gibs = Gibs;
			_bots = Bots;
			_botBullets = BotBullets;
			_botGibs = BotGibs;
			_player = ThePlayer;
			_timer = FlxG.random()*20;
			_open = false;
			health = 8;
			}
		
	}

}