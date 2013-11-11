package
{
	import flash.utils.getDefinitionByName;
	
	import org.flixel.system.*;
	
	[SWF(width="800", height="600", backgroundColor="#000000")] //Set the size and color of the Flash file	
	public class Preloader extends FlxPreloader
	{
		public function Preloader():void
		{
			BigHeadFootballGame;
			className = "BigHeadFootballGame";
			super();
		}
	}
}