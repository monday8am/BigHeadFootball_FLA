package game.actors
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import model.HumanSettings;

	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	import util.Constants;
	
	public class Player extends FlxSprite
	{
		[Embed(source = '../../../assets/audio/actors/disparo.mp3')] private var shootSound : Class;		
		
		private const DEGREETORADIAN : Number = 180 / Math.PI;
		
		protected var ratio : Number = 30;
		
		public var _fixDef  : b2FixtureDef;
		public var _bodyDef : b2BodyDef;
		public var body	    : b2Body;
		public var foot		: b2Body;	
		public var head 	: b2Body;
		public var joint 	: b2RevoluteJoint;
		public var headJoint 	: b2RevoluteJoint;
		
		protected var _world : b2World;
		
		// Default angle
		public var _angle : Number = 0;
		
		// Default body type
		public var _type : uint = b2Body.b2_dynamicBody;
		
		protected var _settings : HumanSettings;
		protected var _canJump  : Boolean = true;
		protected var _canShoot : Boolean = true;
		protected var _canMagic : Boolean = true;
		
		protected var _quickBack : Boolean = true;
		protected var _ballContact : Boolean = false;
		
		protected var _leftFactor : int;
		

		
		public function Player(X:Number, Y:Number, settings : HumanSettings, w:b2World)
		{
			super(X,Y);
			
			this._settings = settings;
			this.width = this._settings.width;
			this.height = this._settings.height;	
			
			// save initials ( bad state machine :( )
			
			this.initialWidth = this._settings.width;
			this.initialHeight = this._settings.height;
			this.initialVelocity = this.settings.velocity;
			this.initialBackwardVelocity = this.settings.backwardVelocity;
			this.initialJump = this.settings.jumpImpulse;
			this.initialDensity = this.settings.density;
			this.initialShootForce = this.settings.shootForce;
			
			if( settings.isHuman ) { _leftFactor  = 1; } else { _leftFactor = -1; }
			this.scale.x = _leftFactor * -1;
			
			
			addAnimation("walk", [0, 1, 2, 3], 10, true);	
			addAnimation("walk_back",[3, 2, 1, 0], 10, true);
			addAnimation("idle", [0], 0, false);
			addAnimation("fail",[6], 0,true);
			addAnimation("jump",[5],0,false);		
			addAnimation("shoot", [0, 4, 4, 4, 0], 20, false);				
			
			_world = w;		
		}
		
		public function get canMagic():Boolean
		{
			return _canMagic;
		}

		public function get ballContact():Boolean
		{
			return _ballContact;
		}

		public function set ballContact(value:Boolean):void
		{
			_ballContact = value;
		}

		public function get canJump():Boolean
		{
			return _canJump;
		}
		
		public function set canJump(value:Boolean):void
		{
			_canJump = value;
		}
		
		public function get canShoot():Boolean
		{
			 
			return body && _quickBack && !_ballContact;
		}
		
		public function get settings() : HumanSettings
		{
			return _settings;
		}	
		
		override public function update() : void
		{
			if(!body) return;

			x = ( body.GetPosition().x * ratio) - width/2;
			y = ( body.GetPosition().y * ratio) - height/2 + 10;
			angle = body.GetAngle() * (180 / Math.PI);				

			if( !_quickBack )
			{
				play( "shoot" );
			}
			else if( canJump )
			{
				if( body.GetLinearVelocity().x > 0.1 )
				{
					play( "walk" );
				}
				else if( body.GetLinearVelocity().x < - 0.1 )
				{
					play( "walk_back" );
				}
				else
				{
					play( "idle" );
				}				
			}
			else if( !canJump )
			{
				if( body.GetLinearVelocity().y > 2 )
				{
					play( "fail" );
				}
				else if( body.GetLinearVelocity().y < - 2 )
				{
					play( "jump" );
				}				
			}
			
			// check foot angle 
			if( settings.isHuman )
			{
				if( joint.GetJointAngle() >= 58 / DEGREETORADIAN )
				{
					foot.ApplyImpulse( new b2Vec2( settings.shootForce, settings.shootForce ), foot.GetWorldCenter());
				}
				
				if( joint.GetJointAngle() < - 0.5 / DEGREETORADIAN && joint.GetJointAngle() != 0 )
				{
					if( _quickBack == false )
					{
						_quickBack = true;
						foot.SetAngle( 0 );
						foot.SetAngularVelocity( 0 );
						foot.SetFixedRotation( true );	
					}
				}				
			}
			else
			{
				if( joint.GetJointAngle() <= -58 / DEGREETORADIAN )
				{
					foot.ApplyImpulse( new b2Vec2( - settings.shootForce, settings.shootForce ), foot.GetWorldCenter());
				}
				
				if( joint.GetJointAngle() > 0.5 / DEGREETORADIAN && joint.GetJointAngle() != 0 )
				{
					if( _quickBack == false )
					{
						_quickBack = true;
						foot.SetAngle( 0 );
						foot.SetAngularVelocity( 0 );
						foot.SetFixedRotation( true );	
					}
				}					
			}
			
			super.update();
		}
		
		public function createBody() : void
		{            
			// remove if exists
			if( body ) 
			{
				_world.DestroyJoint( joint );
				_world.DestroyBody( body );
				_world.DestroyBody( foot );
			}
			
			// create body
			var bd : b2BodyDef = new b2BodyDef();
			bd.type = b2Body.b2_dynamicBody;
			
			// create head
			var circleShape : b2CircleShape = new b2CircleShape( (settings.width/1.7 )/ ratio );
			circleShape.SetLocalPosition( new b2Vec2( 0, - (settings.height/3) / ratio ));
			
			// create box
			var boxShape : b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsOrientedBox( (settings.width/2) / ratio, (settings.height/2.5) / ratio, new b2Vec2( 0,  (settings.height/5) / ratio ), 0  );
			
			var _fixDef : b2FixtureDef = new b2FixtureDef();
			_fixDef.density = this.settings.density;
			_fixDef.restitution = this.settings.restitution;
			_fixDef.friction = this.settings.friction;                        
			
			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set((x  + (settings.width/2)  ) / ratio, (y + (settings.height/2)) / ratio);
			_bodyDef.angle = _angle * (Math.PI / 180);
			_bodyDef.type = _type;
			
			body = _world.CreateBody(_bodyDef);
			body.CreateFixture2( circleShape, 0.0);
			body.CreateFixture2( boxShape, settings.density );
			body.SetFixedRotation( true );
			body.SetUserData( this);
			
			// create foot
			var footShape : b2PolygonShape = new b2PolygonShape();
			var shapeSize : Number = ((settings.height )/2) / ratio;
			if( settings.isHuman )
			{
				footShape.SetAsArray( [ new b2Vec2( 0, 0), new b2Vec2( 0, shapeSize ),  new b2Vec2( -shapeSize/2, shapeSize) ], 3 );
			}
			else
			{
				footShape.SetAsArray( [ new b2Vec2( 0, 0), new b2Vec2( shapeSize/2, shapeSize), new b2Vec2( 0, shapeSize ) ], 3 ); 
			}
			_fixDef.shape = footShape;	
			_fixDef.friction = 0.0;
			_fixDef.density = 0.5;
			_fixDef.restitution = 0.0;				

			foot = _world.CreateBody( _bodyDef );
			foot.CreateFixture( _fixDef );
			foot.SetFixedRotation( true );
			foot.SetUserData( this);

			// revolution joint
			var revoluteJointDef : b2RevoluteJointDef  = new  b2RevoluteJointDef();
			revoluteJointDef.Initialize( body, foot, body.GetWorldCenter() );
			revoluteJointDef.localAnchorA = new b2Vec2( 0, 0 );
			revoluteJointDef.localAnchorB = new b2Vec2( 0, 0 );
			
			revoluteJointDef.referenceAngle = 0;	
			revoluteJointDef.enableLimit = true;
			if( settings.isHuman )
			{
				revoluteJointDef.lowerAngle =  -1 / DEGREETORADIAN;
				revoluteJointDef.upperAngle =  60 / DEGREETORADIAN;					
			}
			else
			{
				revoluteJointDef.lowerAngle =  -60 / DEGREETORADIAN;
				revoluteJointDef.upperAngle =  1 / DEGREETORADIAN;					
			}

			joint = b2RevoluteJoint( _world.CreateJoint(revoluteJointDef));
			
			// init movement variables
			_quickBack = true;
			_ballContact = false;
			_canJump = true;
		}		
		
		/**
		 *  player actions
		 * 
		 */
		public function move( direction : int ):void
		{
			body.SetAwake( true );
			var velocity : Number;
			if( direction == -1 )  { velocity = this.settings.velocity; } else {  velocity = this.settings.backwardVelocity; }
			body.SetLinearVelocity( new b2Vec2( direction * velocity, body.GetLinearVelocity().y ));	
		}
		
		public function jump():void
		{
			if( canJump) 
			{
				body.ApplyImpulse( new b2Vec2( 0.0, -settings.jumpImpulse ), body.GetWorldCenter() );		
			}
		}
		
		public function shoot():void
		{
			if( canShoot )
			{
				_quickBack = false;
				foot.SetFixedRotation( false );
				foot.ApplyImpulse( new b2Vec2( _leftFactor * - settings.shootForce , settings.shootForce ), foot.GetWorldCenter());		
				FlxG.play( shootSound, 0.5 );
			}
		}	
		
		override public function kill() : void
		{
			_world.DestroyJoint( joint );
			_world.DestroyBody( body );
			_world.DestroyBody( foot );
			super.kill();
		}
		
		private var initialVelocity : Number;
		
		private var initialBackwardVelocity : Number;
		
		private var initialWidth : Number;
		
		private var initialHeight : Number;
		
		private var initialJump : Number;
		
		private var initialDensity : Number;
		
		private var initialShootForce : Number;
	}
}