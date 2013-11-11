package game.physics
{
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2ContactListener;
	
	import flash.events.EventDispatcher;
	
	import game.PlayState;
	import game.actors.Ball;
	import game.actors.Floor;
	import game.actors.Player;
	
	import org.flixel.FlxU;
	
	public class PlayerContactListener extends b2ContactListener
	{
		public var eventDispatcher:EventDispatcher;
		
		public function PlayerContactListener()
		{
			eventDispatcher = new EventDispatcher();
		}
		
		override public function BeginContact(contact:b2Contact):void
		{
			var b : Ball;
			
			// ball sound
			if( contact.GetFixtureA().GetBody().GetUserData() is Ball && 
				contact.GetFixtureB().GetBody().GetUserData() is B2FlxTileblock  )
			{
				b = Ball( contact.GetFixtureA().GetBody().GetUserData());
				b.playBallSound( FlxU.getClassName( contact.GetFixtureB().GetBody().GetUserData(), true ));
			}		
			
			if( contact.GetFixtureA().GetBody().GetUserData() is B2FlxTileblock  && 
				contact.GetFixtureB().GetBody().GetUserData() is Ball  )
			{
				b = Ball( contact.GetFixtureB().GetBody().GetUserData());
				b.playBallSound( FlxU.getClassName( contact.GetFixtureA().GetBody().GetUserData(), true ));
			}	

			
			// player can jump 
			if( contact.GetFixtureA().GetBody().GetUserData() is Player && 
				contact.GetFixtureB().GetBody().GetUserData() is Floor  )
			{
				Player( contact.GetFixtureA().GetBody().GetUserData() ).canJump = true;
			}
			
			if( contact.GetFixtureB().GetBody().GetUserData() is Player && 
				contact.GetFixtureA().GetBody().GetUserData() is Floor  )
			{
				Player( contact.GetFixtureB().GetBody().GetUserData() ).canJump = true;
			}

			
			// player can shoot 
			if( contact.GetFixtureA().GetBody().GetUserData() is Player && 
				contact.GetFixtureB().GetBody().GetUserData() is Ball  )
			{
				if( contact.GetFixtureA().GetBody() == Player( contact.GetFixtureA().GetBody().GetUserData()).foot )
				{
					Player( contact.GetFixtureA().GetBody().GetUserData()).ballContact = true;
				}
			}
			
			if( contact.GetFixtureB().GetBody().GetUserData() is Player && 
				contact.GetFixtureA().GetBody().GetUserData() is Ball  )
			{
				if( contact.GetFixtureB().GetBody() == Player( contact.GetFixtureB().GetBody().GetUserData()).foot )
				{
					Player( contact.GetFixtureA().GetBody().GetUserData()).ballContact = true;
				}
			}
			
		}
		
		override public function EndContact(contact:b2Contact):void
		{
			// player can jump
			if( contact.GetFixtureA().GetBody().GetUserData() is Player && 
				contact.GetFixtureB().GetBody().GetUserData() is Floor  )
			{
				Player( contact.GetFixtureA().GetBody().GetUserData() ).canJump = false;
			}
			
			if( contact.GetFixtureB().GetBody().GetUserData() is Player && 
				contact.GetFixtureA().GetBody().GetUserData() is Floor  )
			{
				Player( contact.GetFixtureB().GetBody().GetUserData() ).canJump = false;
			}
			
			// player can shoot 
			if( contact.GetFixtureA().GetBody().GetUserData() is Player && 
				contact.GetFixtureB().GetBody().GetUserData() is Ball  )
			{
				if( contact.GetFixtureA().GetBody() == Player( contact.GetFixtureA().GetBody().GetUserData()).foot )
				{
					Player( contact.GetFixtureA().GetBody().GetUserData()).ballContact = false;
				}
			}
			
			if( contact.GetFixtureB().GetBody().GetUserData() is Player && 
				contact.GetFixtureA().GetBody().GetUserData() is Ball  )
			{
				if( contact.GetFixtureB().GetBody() == Player( contact.GetFixtureB().GetBody().GetUserData()).foot )
				{
					Player( contact.GetFixtureA().GetBody().GetUserData()).ballContact = false;
				}
			}			
		}		
	}
}