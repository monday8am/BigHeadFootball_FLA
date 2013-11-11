package game
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	public class MenuState extends FlxState
	{
		private var assets : MovieClip;
		
		public function MenuState()
		{
			super();
		}
		
		override public function create():void
		{	
			var text : FlxText = new FlxText( FlxG.width /2, FlxG.height /2, 500, "MENU STATE", false );
			text.size = 80;
			add( text );
			text.x -= text.width /2;
			text.y -= text.height;
			
			var playBtn : FlxButton = new FlxButton(  FlxG.width/2, FlxG.height/2 + 60, "Play Game", onPlay );
			add( playBtn );
			playBtn.x -= playBtn.width /2;			
			
			var helpBtn : FlxButton = new FlxButton(  FlxG.width/2, FlxG.height/2 + 90, "Help", onHelp );
			add( helpBtn );
			helpBtn.x -= helpBtn.width /2;					
			
		}
		
		private function onPlay( e : Event = null ):void
		{
			FlxG.switchState( new PlayState());
		}
		
		private function onHelp( e : Event = null ):void
		{
			FlxG.switchState( new HelpState());
		}	
		
		override public function destroy():void
		{
			super.destroy();
			assets = null;
		}
	}
}