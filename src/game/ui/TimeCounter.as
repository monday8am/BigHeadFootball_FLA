package game.ui
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.EndState;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;

	public class TimeCounter extends FlxSprite
	{
		private var timeCountMc  : MovieClip;
		private var delayCountMc : MovieClip;
		private var finalMc 	 : MovieClip;
		
		private var finishedGame  : Boolean = false;
		
		public function TimeCounter(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			super(X, Y, SimpleGraphic);
			
			timeCountMc = new timeCounterAsset(); 
			FlxG.camera.getContainerSprite().addChild( timeCountMc );		
			timeCountMc.x = X - FlxG.width / 2;
			timeCountMc.y = Y - FlxG.height / 2;

			delayCountMc = new delayCounterAsset(); 
			FlxG.camera.getContainerSprite().addChild( delayCountMc );		
			delayCountMc.x = X - FlxG.width / 2;
			delayCountMc.y = Y - FlxG.height / 2;	
			
			finalMc = new endTimeAsset(); 
			FlxG.camera.getContainerSprite().addChild( finalMc );		
			finalMc.x = (FlxG.width - finalMc.width)/2 - FlxG.width/2;
			finalMc.y = (FlxG.height - finalMc.height)/2- FlxG.height/2;	
			finalMc.aceptar.addEventListener( MouseEvent.CLICK, onPressEnd );
			finalMc.visible = false;
		}
		
		public function setTeams( computer : int, human : int  ):void
		{
			timeCountMc.teamComputer.gotoAndStop( 3);
			timeCountMc.teamHuman.textField.text = "Human";
		}
		
		public function finishGame( score : Point, ranking : int, points : int, goalPoints : int ):void
		{
			finished = true;
			delayCountMc.visible = false;
			timeCountMc.visible  = false;	
			finalMc.visible = true;
			
			var win : String = "0";
			var mej : int = 0;
			
			if( score.x > score.y )
			{
				finalMc.mensajes.gotoAndStop(2);
			}
			else if ( score.y > score.x )
			{
				win = "+3";
				mej = 3 + goalPoints;			
				finalMc.mensajes.gotoAndStop(1);
			}
			else
			{
				win = "+1";
				mej = goalPoints;
				finalMc.mensajes.gotoAndStop(3);
			}
			
			finalMc.pantalla_b.ranking.text = win;
			finalMc.pantalla_b.totalr.text = "TOTAL " +  points;
		}		
		
		public function updateScore( time : int, delayTime : int, score : Point ):void
		{
			timeCountMc.scoreTxt.text = score.x + "-" + score.y;
			timeCountMc.timeTxt.text = Math.ceil( time/1000 ) + "''"; 
			delayCountMc.timeTxt.text = Math.ceil( delayTime/1000 ) + "''"; 
		}
		
		override public function update():void
		{
			if( !finishedGame )
			{
				delayCountMc.visible = FlxG.paused;
				timeCountMc.visible = !FlxG.paused;				
			}
		}
		
		private function onPressEnd( e : MouseEvent ):void
		{
			FlxG.switchState( new EndState());
		}
		
		override public function destroy():void
		{
			finalMc.aceptar.removeEventListener( MouseEvent.CLICK, onPressEnd );
			/*
			 //timeCountMc = null;
			FlxG.camera.getContainerSprite().removeChild( finalMc ); //finalMc = null;
			FlxG.camera.getContainerSprite().removeChild( delayCountMc ); //delayCountMc = null;*/
			timeCountMc = null;
			finalMc = null;
			delayCountMc = null;
			
			super.destroy();
		}		
	}
}