package game
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	import game.actors.Ball;
	import game.actors.Floor;
	import game.actors.Player;
	import game.actors.VirtualGoals;
	import game.physics.B2FlxTileblock;
	import game.physics.PlayerContactListener;
	import game.ui.TimeCounter;
	
	import model.ComputerSettings;
	import model.HumanSettings;
	
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxState;
	import org.flixel.FlxTimer;
	import org.flixel.FlxU;
	
	public class PlayState extends FlxState
	{
		[Embed(source = '../../assets/audio/actors/ambiente.mp3')] private var goalSound : Class;
		[Embed(source = '../../assets/audio/actors/final.mp3')] private var finalSound : Class;

		private static const LEFT : int  = - 1;
		private static const RIGHT : int = 1;
		
		public var _world : b2World;
		
		// state
		private var gameTime : int = 60;
		private var delayTime : int = 1;
		private var gameResult : Point = new Point();
		
		// actors
		private var human 	 : Player;
		private var computer : Player;
		private var ball 	 : Ball;
		private var score	 : TimeCounter;
		private var floor	 : Floor;
		
		private var floorPos	: int   =  450;
		private var computerPos : Point = new Point( FlxG.width / 2 - 100, 100);
		private var humanPos 	: Point = new Point( FlxG.width / 2 + 100, 100);
		private var ballPos 	: Point = new Point( FlxG.width / 2, 100);
		private var xPos :		int = 0;

		private var goalsSize:Point;

		
		public function PlayState()
		{
			super();
		}	
		
		override public function create():void
		{
			setupWorld();
			
			// 
			var computerSettings : ComputerSettings = new ComputerSettings();
			var humanSettings : HumanSettings = new HumanSettings();
			
			// define positions
			floorPos	=  450;
			computerPos = new Point( FlxG.width / 2 - 150, floorPos - humanSettings.height - 5 );
			humanPos 	= new Point( FlxG.width / 2 + 150, floorPos - humanSettings.height - 5 );
			ballPos 	= new Point( FlxG.width / 2, 100);			
			
			//
			score = new TimeCounter( FlxG.width / 2 - 56, 132 );
			
			// add actors
			human = new Player( humanPos.x, humanPos.y, humanSettings, _world );
			computer = new Player( computerPos.x, computerPos.y, computerSettings, _world );		
			ball = new Ball( ballPos.x, ballPos.y, 20 / 2, _world );
			ball.alpha = computer.alpha = human.alpha = 0;
			
			var fieldSize : Point = new Point( 800,200);
			goalsSize = new Point( 42, 143 );
			xPos  = (FlxG.width - fieldSize.x )/2;
			
			//floor:
			floor = new Floor( xPos , floorPos, fieldSize.x, fieldSize.y, _world )
			floor.createBody();
			
			//walls:
			var top : B2FlxTileblock = new B2FlxTileblock( xPos -5, 0, fieldSize.x, 5, _world ); top.createBody();
			var wallLeft : B2FlxTileblock = new B2FlxTileblock( xPos -5, 0, 5, floorPos, _world ); wallLeft.createBody();
			var wallRight : B2FlxTileblock = new B2FlxTileblock( xPos  + fieldSize.x, 0, 5, floorPos, _world ); wallRight.createBody();
			
			// goals
			var goalLeft : VirtualGoals = new VirtualGoals( xPos , floor.y - goalsSize.y, goalsSize.x, 10, _world ); goalLeft.createBody(); 
			var goalRight : VirtualGoals = new VirtualGoals( xPos  + floor.width - goalsSize.x, floor.y - goalsSize.y, goalsSize.x, 10, _world ); goalRight.createBody();
			goalLeft._obj.SetAngle(  Math.PI / 180 * 3  );
			goalRight._obj.SetAngle( Math.PI / 180 * -3  );
			
			add( floor );
			add( goalLeft );add( goalRight );
			add( top );add( wallLeft );add( wallRight );
			add( score );
			add( human );
			add( computer );
			add( ball );
			
			// set game settings
			gameResult.x = 0; gameResult.y = 0;
			gameTime = 60000; // 1 minute
			//if( Capabilities.isDebugger ) gameTime = 15000;
			delayTime = 2000 // 5 seconds
			score.setTeams( computer.settings.team, human.settings.team );
			
			// 
			debugDraw();
			
			// start play
			startPlay();
		}
		

		private function setupWorld():void
		{
			var gravity : b2Vec2 = new b2Vec2( 0, 9.8 );
			_world = new b2World( gravity, true);
			_world.SetContactListener( new PlayerContactListener());
		}
		
		/**
		* game main loop
		*
		*/ 
		override public function update():void
		{
			// update Box2D world..
			_world.Step( 1/60, 10, 10 );
			
			// update FX
			updateFx();
			
			// debug
			_world.DrawDebugData()
			
			// check for AI
			runAI();
			
			// check for goals
			checkGameRules();
			
			// update time counter
			score.updateScore( gameTime, delayTime, gameResult );

			//
			super.update();	
		}	
		
		
		/**
		 * controll operations
		 * 
		 */
		private function checkGameRules():void
		{
			
			if( !FlxG.paused )
			{
				if( FlxG.keys.LEFT )
				{
					human.move( LEFT );
				} 
				else if( FlxG.keys.RIGHT )
				{
					human.move( RIGHT );
				}	
				
				if( FlxG.keys.UP )
				{
					human.jump();
				}	
				
				if( FlxG.keys.SPACE )
				{
					human.shoot();
				}					
				
				gameTime -= FlxG.elapsed * 1000;
				
				if( gameTime <= 0 )
				{
					// restore players
					human.x = humanPos.x; human.y = humanPos.y;
					human.createBody();
				
					// play sound
					FlxG.play( finalSound, 0.8 );
					FlxG.paused = true;
					
					FlxG.switchState( new EndState() );
				}
				
				var s : FlxSound;
				
				// human goal
				if( ball.x < xPos + goalsSize.x - ball.width && 
					ball.y > floor.y - goalsSize.y )
				{
					// play sound
					s = FlxG.play( goalSound , 0.3 );
					gameResult.y++;
					startPlay();
				}
				
				// computer goal
				if( ball.x > xPos  + floor.width - goalsSize.x - ball.width/2 && 
					ball.y > floor.y - goalsSize.y )
				{
					s = FlxG.play( goalSound , 0.3 );	
					gameResult.x++;
					startPlay();
				}			
			}
			else
			{
				delayTime -= FlxG.elapsed * 1000;
			}
		}
		

		private function startPlay():void
		{
			FlxG.paused = true;
			
			TweenMax.to( computer, 0.4, { autoAlpha: 0 } );
			TweenMax.to( human, 0.4, { autoAlpha: 0 } );
			TweenMax.to( ball, 0.4, { autoAlpha: 0, onComplete : showPlayers });
			
			delayTime = 2000;
			var flxTimer : FlxTimer = new FlxTimer();
			flxTimer.start( 2, 1, start );
			
			function showPlayers() : void
			{
				computer.x = computerPos.x; computer.y = computerPos.y;
				computer.createBody();
				
				human.x = humanPos.x; human.y = humanPos.y;
				human.createBody();
				
				ball.x = ballPos.x; ball.y = ballPos.y;
				ball.createBody();
				ball.body.SetActive( false );
				var initialImpulse : b2Vec2 = new b2Vec2( FlxG.random()/5, FlxG.random()/5 );
				ball.body.ApplyImpulse( initialImpulse, ball.body.GetWorldCenter() );

				TweenMax.to( computer, 0.3, { autoAlpha: 1} );
				TweenMax.to( human, 0.3, { autoAlpha: 1} );
				TweenMax.to( ball, 0.3, { autoAlpha: 1 });	
			}
			
			function start():void
			{
				FlxG.play( finalSound, 0.5 );
				ball.body.SetActive( true );
				FlxG.paused = false;
			}
		}
		
		
		private function runAI():void
		{
			var ballX : Number;
			var ballY : Number;
			var computerX : Number;
			var computerY : Number;
			var humanX : Number;
			var humanY : Number;			
			
			var dist : Number;
			
			//if( Capabilities.isDebugger ) return;
			
			if( !FlxG.paused )
			{
				ballX = ball.body.GetPosition().x;
				ballY = ball.body.GetPosition().y;
				computerX = computer.body.GetPosition().x;
				computerY = computer.body.GetPosition().y;	
				humanX = human.body.GetPosition().x;
				humanY = human.body.GetPosition().y;						
				
				dist = FlxU.getDistance( new FlxPoint( ballX, ballY), new FlxPoint( computerX, computerY ));
				var distX : Number = computerX - ballX;
				var distY : Number = computerY - ballY;
				var distPlayer : Number = FlxU.getDistance( new FlxPoint( computerX, computerY), new FlxPoint( humanX, humanY ));

				if( dist < 5 )
				{
					// movement 
					if( distX > - 3.5 && distX < - 1 ) 
					{
						computer.move( RIGHT );
					}
					else if( distX > 0 ) 
					{
						computer.move( LEFT );	
					}
					
					// jump
					if( distY > 1.5 && distY < 3.5)
					{
						computer.jump();
					}					
					/**/
					
					// shoot
					if( distY < 0 && distY > -1 && distX < -0.7 && distX > -1.5  )
					{		
						
						computer.shoot();
					}
					
				}
				
				if( dist >= 5 )
				{
					if( ballX - computerX > 0 ) computer.move( RIGHT );
					if( ballX - computerX < -2 ) computer.move( LEFT );					
				}
			}
		}
		

		/**
		 * utils
		 **/	
		private function debugDraw():void
		{
			var spriteToDrawOn : Sprite = new Sprite();
			FlxG.camera.getContainerSprite().addChild( spriteToDrawOn);
			spriteToDrawOn.x = - spriteToDrawOn.stage.stageWidth /2;
			spriteToDrawOn.y = - spriteToDrawOn.stage.stageHeight /2;
			
			var artistForHire : b2DebugDraw = new b2DebugDraw();
			artistForHire.SetSprite(spriteToDrawOn);
			artistForHire.SetDrawScale( 30 );
			artistForHire.SetFlags( b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit | b2DebugDraw.e_centerOfMassBit );
			artistForHire.SetLineThickness(2.0);
			artistForHire.SetFillAlpha(0.6);
			_world.SetDebugDraw( artistForHire);
		}
		
		private function updateFx(): void
		{
			
		}
		

		override public function destroy():void
		{
			// 
			_world = null;
			
			super.destroy();
		}	
		

		
		
	}
}