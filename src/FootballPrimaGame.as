package
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import game.EndState;
	import game.MenuState;
	import game.PlayState;
	
	import model.HumanSettings;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.plugin.DebugPathDisplay;

	[SWF(width="800", height="600" )] //Set the size and color of the Flash file
	public class FootballPrimaGame extends FlxGame
	{
		public function FootballPrimaGame()
		{
			super( 800, 600, MenuState, 1, 60, 30, true );
		}
	}
}