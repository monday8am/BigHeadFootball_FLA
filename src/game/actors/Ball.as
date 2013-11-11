package game.actors
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2MouseJoint;
	import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.ui.Mouse;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;


	
	public class Ball extends FlxSprite
	{
		[Embed(source = '../../../assets/audio/actors/toque.mp3')] private var ballSound : Class;
		[Embed(source = '../../../assets/audio/actors/larguero.mp3')] private var ballSoundGoal : Class;
		[Embed(source = '../../../assets/textures/actors/ball.png')] private var ImgBall : Class;
		
		// pixels per metro..
		private var ratio : Number = 30;
		
		public var _fixDef		: b2FixtureDef;
		public var _bodyDef 	: b2BodyDef;
		public var body			: b2Body;
		
		private var _radius : Number;
		private var _world  : b2World;
		
		//Physics params default value
		public var _friction	: Number = 0.4;
		public var _restitution : Number = 0.6;
		public var _density		: Number = 0.2;
		
		//Default angle
		public var _angle		: Number = 0;
		
		//Default body type
		public var _type : uint = b2Body.b2_dynamicBody;


		public function Ball( X:Number, Y:Number, Radius:Number, w:b2World):void
		{
			super(X,Y);
			
			_radius = Radius;
			_world = w;
			loadGraphic( ImgBall, false, false, 20, 20);
			
		}
		
		override public function update():void
		{
			if(!body) return;
			x = (body.GetPosition().x * ratio ) - _radius;
			y = (body.GetPosition().y * ratio ) - _radius;
			angle = body.GetAngle() * ( 180 / Math.PI );
			super.update();	
		}
		
		public function createBody():void
		{
			if( body ) _world.DestroyBody(body);
			
			_fixDef = new b2FixtureDef();
			_fixDef.friction = _friction;
			_fixDef.restitution = _restitution;
			_fixDef.density = _density;
			_fixDef.shape = new b2CircleShape( _radius / ratio );
			
			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set((x + (_radius)) / ratio, (y + (_radius/2)) / ratio);
			_bodyDef.angle = _angle * (Math.PI / 180);
			_bodyDef.type = _type;
			
			body = _world.CreateBody(_bodyDef);
			body.CreateFixture(_fixDef);
			body.SetUserData( this );
		}
		
		public function playBallSound( surface : String ):void
		{
			if( surface == "Floor" )
			{
				FlxG.play( ballSound, 0.8);
			}
			else
			{
				FlxG.play( ballSoundGoal, 0.8);
			}			
		}

		
		override public function kill():void
		{
			_world.DestroyBody(body);
			super.kill();
		}	
	}
}