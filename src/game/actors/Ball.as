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
		
		/**/
		//======================
		// Member Data 
		//======================
		public var m_world:b2World;
		public var m_bomb:b2Body;
		public var m_mouseJoint:b2MouseJoint;
		public var m_velocityIterations:int = 10;
		public var m_positionIterations:int = 10;
		public var m_timeStep:Number = 1.0/30.0;
		public var m_physScale:Number = 30;
		// world mouse position
		static public var mouseXWorldPhys:Number;
		static public var mouseYWorldPhys:Number;
		static public var mouseXWorld:Number;
		static public var mouseYWorld:Number;		
		
		//======================
		// Update mouseWorld
		//======================
		public function UpdateMouseWorld():void{
			mouseXWorldPhys = (FlxG.mouse.screenX)/m_physScale; 
			
			mouseYWorldPhys = (FlxG.mouse.screenY)/m_physScale; 
			
			mouseXWorld = (FlxG.mouse.screenX); 
			mouseYWorld = (FlxG.mouse.screenY); 
		}
		
		
		//======================
		// Mouse Drag 
		//======================
		public function MouseDrag():void{
			// mouse press
			if ( FlxG.mouse.justPressed() && !m_mouseJoint){
				
				var body:b2Body = GetBodyAtMouse();
				
				if (body)
				{
					var md:b2MouseJointDef = new b2MouseJointDef();
					md.bodyA = _world.GetGroundBody();
					md.bodyB = body;
					md.target.Set(mouseXWorldPhys, mouseYWorldPhys);
					md.collideConnected = true;
					md.maxForce = 300.0 * body.GetMass();
					m_mouseJoint = _world.CreateJoint(md) as b2MouseJoint;
					body.SetAwake(true);
				}
			}
			
			
			// mouse release
			if (!FlxG.mouse.justPressed()){
				if (m_mouseJoint)
				{
					_world.DestroyJoint(m_mouseJoint);
					m_mouseJoint = null;
				}
			}
			
			
			// mouse move
			if (m_mouseJoint)
			{
				var p2:b2Vec2 = new b2Vec2(mouseXWorldPhys, mouseYWorldPhys);
				m_mouseJoint.SetTarget(p2);
			}
		}
		
		
		
		//======================
		// Mouse Destroy
		//======================
		public function MouseDestroy():void{
			// mouse press
			return;
			if (!FlxG.mouse.justPressed() ){
				
				var body:b2Body = GetBodyAtMouse(true);
				
				if (body)
				{
					_world.DestroyBody(body);
					return;
				}
			}
		}
		
		
		
		//======================
		// GetBodyAtMouse
		//======================
		private var mousePVec:b2Vec2 = new b2Vec2();
		public function GetBodyAtMouse(includeStatic:Boolean = false):b2Body {
			// Make a small box.
			mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
			var body:b2Body = null;
			var fixture:b2Fixture;
			
			// Query the world for overlapping shapes.
			function GetBodyCallback(fixture:b2Fixture):Boolean
			{
				var shape:b2Shape = fixture.GetShape();
				if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic)
				{
					var inside:Boolean = fixture.TestPoint( mousePVec );
					if (inside)
					{
						body = fixture.GetBody();
						return false;
					}
				}
				return true;
			}
			_world.QueryAABB(GetBodyCallback, aabb);
			return body;
		}	
		
	}
}