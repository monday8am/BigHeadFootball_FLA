package game
{

	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;

	
	public class HelpState extends FlxState
	{

		public function HelpState()
		{
			super();
		}
		
		override public function create():void
		{
			var text : FlxText = new FlxText( FlxG.width /2, FlxG.height /2, 500, "HELP STATE", false );
			text.size = 80;
			add( text );
			text.x -= text.width /2;
			text.y -= text.height;
			
			var backBtn : FlxButton = new FlxButton(  FlxG.width/2, FlxG.height/2 + 60, "Back to Menu", onBack );
			add( backBtn );
			backBtn.x -= backBtn.width /2;	
		}
		
		private function onBack():void
		{
			FlxG.switchState( new MenuState());
		}		

		override public function destroy():void
		{
			super.destroy();
		}			
	}
}