package
{
	import flash.utils.getDefinitionByName;
	
	import org.flixel.system.*;
	
	[SWF(width="1000", height="570", backgroundColor="#000000")] //Set the size and color of the Flash file	
	public class Preloader extends FlxPreloader
	{
		public function Preloader():void
		{
			FootballPrimaGame;
			className = "FootballPrimaGame";
			super();
		}
	}
}