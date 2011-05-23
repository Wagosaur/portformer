package
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
	
	import org.flixel.*; //Allows you to refer to flixel objects in your code
	import com.MakeShiftUniverse.Portformer.*;
	
	[SWF(width="640", height="480", backgroundColor="#000000")] //Set the size and color of the Flash file
	[Frame(factoryClass="Preloader")] //Activate the preloader
	public class Portformer extends FlxGame
	{
		public function Portformer()
		{
			super(640,480,PlayState,1); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		}
	}
}






/*

TODO:preloader
TODO:Find a name for player, art him up a bunch
TODO:change controller
TODO:fix camera
TODO:add walljump
TODO:make abilitys pickups






*/