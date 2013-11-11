package model
{
	import util.Constants;

	public class HumanSettings
	{
		public var isHuman 	   : Boolean = true;
		
		public var team   	   : int = 0;
		
		public var velocity    : Number = Constants.MIN_VELOCITY;
		
		public var backwardVelocity  : Number = Constants.MIN_BACKWARD_VELOCITY;
		
		public var jumpImpulse : Number = Constants.MIN_JUMP;
		
		public var shootForce  : Number = Constants.MIN_SHOOT;

		public var friction    : Number = 0.3;
		
		public var restitution : Number = 0.0;
		
		public var density     : Number = 1.6;	
		
		public var width 	   : int = 30;
		
		public var height 	   : int = 80;
	}
}