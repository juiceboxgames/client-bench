package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.media.AudioPlaybackMode;
	import flash.media.SoundMixer;
	
	import starling.core.Starling;
	
	[SWF(width="960", height="640", frameRate="60", backgroundColor="#FFFFFF")]
	public class Main extends Sprite
	{
		
		public static var instance:Main;
		
		protected var mStarling:Starling;
		
		public function Main()
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			super();
			SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
			this.stage.frameRate = 60;
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW
			instance = this;
			// create our Starling instance
			mStarling = new Starling(StarlingStage, stage);
			
			// set anti-aliasing (higher the better quality but slower performance)
			mStarling.antiAliasing = 1;
			
			mStarling.stage.stageWidth  = 480;
			mStarling.stage.stageHeight = 320;	
			
			// start it!
			mStarling.start();
		}
	}
}