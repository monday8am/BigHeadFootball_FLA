package model
{
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	import util.Constants;

	public class ComputerSettings extends HumanSettings
	{
		public function ComputerSettings()
		{
			super();
			
			team   	    = randRange( 1, 3);
			
			velocity    = randRange( Constants.MIN_VELOCITY, Constants.MAX_VELOCITY );
			
			backwardVelocity  = randRange( Constants.MIN_BACKWARD_VELOCITY, Constants.MAX_BACKWARD_VELOCITY );
			
			jumpImpulse = randRange( Constants.MIN_JUMP, Constants.MAX_JUMP );
			
			shootForce  = randRange( Constants.MIN_SHOOT, Constants.MAX_SHOOT );

			friction  = 0.3;
			
			restitution = 0.0;
			
			density    = 0.8;	
			
			width 	   = 30;
			
			height 	   = 80;
			
			isHuman    = false;
		}
		
		private function randRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}			
	}
}