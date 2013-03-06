package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.AudioPlaybackMode;
	import flash.media.SoundMixer;
	
	import starling.core.Starling;
	

	public class Main extends Sprite
	{
		
		public static var instance:Main;
		
		protected var mStarling:Starling;
		
		public function Main()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(evt:*):void{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
			this.stage.frameRate = 60;
			// support autoOrients
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.quality = StageQuality.LOW
			instance = this;
			//stage.displayState = StageDisplayState.FULL_SCREEN;
			// create our Starling instance
			mStarling = new Starling(StarlingStage, stage);
			stage.addEventListener(Event.RESIZE, fitViewport);
			this.fitViewport();
			mStarling.addEventListener(Event.CONTEXT3D_CREATE, function(e:*):void{
				fitViewport();
				
				trace("Factor is " + mStarling.contentScaleFactor);
			});
			mStarling.stage.stageWidth  = 480;
			mStarling.stage.stageHeight = 320;	
			
			// start it!
			mStarling.start();
		}
		
		protected function fitViewport(evt:* = null):void{
			mStarling.viewPort = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
		}
		
	
	}
}