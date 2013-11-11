package game.physics
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import org.flixel.FlxSprite;

	
	public class B2FlxSprite extends FlxSprite
	{
		protected var ratio : Number = 30;
		
		public var _fixDef  : b2FixtureDef;
		public var _bodyDef : b2BodyDef;
		public var _obj     : b2Body;
		
		protected var _world : b2World;
		
		// Physics params default value
		public var _friction    : Number = 0.8;
		public var _restitution : Number = 0.3;
		public var _density     : Number = 0.7;
		
		// Default angle
		public var _angle : Number = 0;
		
		// Default body type
		public var _type : uint = b2Body.b2_dynamicBody;
		
		
		public function B2FlxSprite(X:Number, Y:Number, Width:Number, Height:Number, w:b2World):void
		{
			super(X,Y);
			
			width = Width;
			height = Height;
			_world = w
		}
		
		override public function update():void
		{
			x = ( _obj.GetPosition().x * ratio) - width/2 ;
			y = ( _obj.GetPosition().y * ratio) - height/2;
			angle = _obj.GetAngle() * (180 / Math.PI);
			super.update();
		}
		
		public function createBody():void
		{            
			var boxShape : b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox(( width / 2 ) / ratio, ( height / 2) / ratio );
			
			_fixDef = new b2FixtureDef();
			_fixDef.density = _density;
			_fixDef.restitution = _restitution;
			_fixDef.friction = _friction;                        
			_fixDef.shape = boxShape;

			_bodyDef = new b2BodyDef();
			_bodyDef.position.Set((x + (width/2)) / ratio, (y + (height/2)) / ratio);
			_bodyDef.angle = _angle * (Math.PI / 180);
			_bodyDef.type = _type;
			
			_obj = _world.CreateBody(_bodyDef);
			_obj.CreateFixture(_fixDef);
		}
		
		override public function kill():void
		{
			_world.DestroyBody(_obj);
			super.kill();
		}		
	}
}
