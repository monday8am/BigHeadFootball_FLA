package game.actors
{
	import Box2D.Dynamics.b2World;
	
	import game.physics.B2FlxTileblock;
	
	public class Floor extends B2FlxTileblock
	{
		public function Floor(X:Number, Y:Number, Width:Number, Height:Number, w:b2World)
		{
			super(X, Y, Width, Height, w);
		}
	}
}