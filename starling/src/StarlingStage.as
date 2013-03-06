package
{

	
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import mx.controls.Image;
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	import dragonBones.objects.SkeletonAndTextureAtlasData;
	import dragonBones.objects.SubTextureData;
	
	import org.villekoskela.utils.RectanglePacker;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	
	public class StarlingStage extends starling.display.Sprite
	{

		// Embed the Atlas XML
		[Embed(source="assets/starling-atlas.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source="assets/starling-atlas.png")]
		public static const AtlasTexture:Class;
		
		private var m_queueBenchmark:Boolean;
		
		private var m_currentClips:Vector.<MovieClip>;
		
		
		protected var m_textureAtlas:TextureAtlas;
		
		/**
		 * Effort level to apply on each frame
		 */
		protected var m_benchmarkEffortLevel:int;
		
		/**
		 * Queued Benchmarks
		 */
		protected var m_queuedBenchmarks:Array;
		
		/**
		 * Collection of results
		 */
		protected var m_results:Array;
		
		protected var m_currentBenchmark:Object;
		
		protected var m_framesRendered:int;
		
		protected var m_durationSeconds:int = 10;
		
		protected var m_effortLevel:int = 0;
		
		protected var m_result:Number;
		
		public function StarlingStage()
		{
			var image:starling.display.Image = new Image(Texture.fromColor(480, 320, 0xFFFFFFFF));
			this.addChild(image);
			m_results = new Array();
			m_queuedBenchmarks = new Array();
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAdded);
			addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		protected function onEnterFrame():void{
			m_framesRendered++;
			if(m_effortLevel > 0){
				m_result = 0;
				for(var i:int = 0; i < m_effortLevel; i++){
					for(var j:int = 0; j < m_effortLevel; j++){
						m_result += Math.sin(i) * Math.cos(j);
					}	
				}
			}
		}
		
		private function onAdded ( e:starling.events.Event ):void
		{
			trace("STARTING");
			m_textureAtlas = new TextureAtlas(Texture.fromBitmap(new AtlasTexture()), new XML(new AtlasXml()));
			queueBenchmark("Benchmark 1", 10, false, 0);
			queueBenchmark("Benchmark 2", 50, false, 0);
			queueBenchmark("Benchmark 3", 250, false, 0);
			queueBenchmark("Benchmark 4", 500, false, 0);
			
			queueBenchmark("Benchmark 5", 10, true, 0);
			queueBenchmark("Benchmark 6", 50, true, 0);
			queueBenchmark("Benchmark 7", 250, true, 0);
			queueBenchmark("Benchmark 8", 500, true, 0);
			
			
			queueBenchmark("Benchmark 9", 100, true, 5);
			queueBenchmark("Benchmark 10", 100, true, 10);
			queueBenchmark("Benchmark 11", 100, true, 15);
			queueBenchmark("Benchmark 12", 100, true, 20);
			queueBenchmark("Benchmark 13", 100, true, 25);
			queueBenchmark("Benchmark 14", 100, true, 35);
			queueBenchmark("Benchmark 15", 100, true, 50);
			doNextBenchmark();
		}
		
		protected function doNextBenchmark():void{
			if(m_queuedBenchmarks.length > 0){
				m_currentBenchmark = m_queuedBenchmarks.shift();
				doBenchmark(m_currentBenchmark.name, m_currentBenchmark.spriteCount, m_currentBenchmark.doTween, m_currentBenchmark.effortLevel);
			} else{
				doWrapup();	
			}
		}
		
		protected function doWrapup():void{
			var y:int = 0;
			for(var i:int = 0; i < m_results.length; i++){
				var textField:TextField = new TextField(100, 20, m_results[i].name + ": " + m_results[i].fps);
				textField.y = y;
				y += 10;
				textField.fontSize = 8;
				this.addChild(textField);
			}
		}
		
		protected function queueBenchmark(name:String, spriteCount:int, doTween:Boolean, effortLevel:int):void{
			m_queuedBenchmarks.push({name:name, spriteCount:spriteCount, doTween:doTween, effortLevel:effortLevel});
		}
		
		protected function doBenchmark(name:String, spriteCount:int, doTween:Boolean, effortLevel:int):void{
			trace("Staring benchmark: " + name);
			m_framesRendered = 0;
			this.m_effortLevel = effortLevel;
			addClips(spriteCount, doTween);
			setTimeout(endBenchmark, m_durationSeconds * 1000);
		}
		
		protected function endBenchmark():void{
			trace("Ending benchmark: " + m_currentBenchmark.name);
			m_results.push({name:m_currentBenchmark.name, fps:m_framesRendered / m_durationSeconds});;
			trace("FPS : " + m_framesRendered / m_durationSeconds);
			for(var i:int = 0; i < m_currentClips.length; i++){
				Starling.juggler.remove(m_currentClips[i]);
				removeChild(m_currentClips[i]);
			}
			setTimeout(doNextBenchmark, 1500);
		}
		
		protected function addClips(count:int, tween:Boolean):void{
			m_currentClips = new Vector.<MovieClip>();
			for(var i:int = 0; i < count; i++){
				addClip(tween);	
			}
		}
		
		protected function addClip(tween:Boolean):void{
			var movieClip:MovieClip = new MovieClip(m_textureAtlas.getTextures(), 60);
			movieClip.loop = true;
			movieClip.currentFrame = Math.floor(Math.random() * 10);
			movieClip.play();
			movieClip.x = 20 + Math.floor(Math.random() * (480 - 40));
			movieClip.y = 20 + Math.floor(Math.random() * (320 - 40));
			Starling.juggler.add(movieClip);
			if(tween){
				moveClip(movieClip);	
			}
			this.addChild(movieClip);
			m_currentClips.push(movieClip);
		}
		
		protected function moveClip(clip:MovieClip):void{
			var targetX:int = 20 + Math.floor(Math.random() * (480 - 40));
			var targetY:int = 20 + Math.floor(Math.random() * (320 - 40));
			Starling.juggler.tween(clip, 1.5, {
				transition: Transitions.LINEAR,
				repeatCount: 1,
				onComplete: function():void { moveClip(clip) },
				x: targetX,
				y: targetY
			});
		}
	}
}