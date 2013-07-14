package org.puremvc.as3.demos.spaceinvadors.view.components {
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import org.puremvc.as3.demos.spaceinvadors.view.ApplicationMediator;
	
	public class SpaceBody extends Sprite {	
		/**
		 * Position of the image in the mask
		 * @return Point
		 */
		protected function get _imgMaskPosition():Point {
			return new Point(0, 0);
		}

		private var fileRequest:URLRequest;
		
		protected var loader:Loader;
		
		protected const settings:XML = ApplicationMediator._settings();
		
		
		public function SpaceBody()
		{
			super();
			/*
			EventListener events 
			*/
			addEventListener(SpaceBodyEvent.ON_CRASH, onCrash);
			addEventListener(SpaceBodyEvent.ON_MOVE, onMove, false, 0, true);
			addEventListener(SpaceBodyEvent.ON_REBORN, onReBorn, false, 0, true);
			
			/*
			Loading image into the movieclip
			*/
			loader = new Loader();
			fileRequest = new URLRequest(settings.theme.@src);
			//loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoaderProgress);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderReady);
			loader.load(fileRequest);
			loader.cacheAsBitmap = true;
			
			addChild(loader);
		}
		
		/**
		 * Mask for biding only selected images from image layout
		 * @param width Number
		 * @param height Number
		 * 
		 */		
		protected function _createMask(width:Number, height:Number):void {
			var mask:Sprite = new Sprite();
			var maskGraphics:Graphics = mask.graphics;
			maskGraphics.beginFill(0x000000);
			maskGraphics.drawRect(0, 0, width, height);
			maskGraphics.endFill();
			mask.x = - Math.round(mask.width/2);
			mask.y = - Math.round(mask.height/2)
				
			this.mask = mask;
			addChild(mask);
		}
		
		/**
		 * Unload events and image from the memory
		 * 
		 */		
		public function __unload():void {
			if(loader != null) {
				removeChild(loader);
				loader.unload();
				loader = null;
			}
			
			if(parent && this != null)
				parent.removeChild(this);
			
			removeEventListener(SpaceBodyEvent.ON_MOVE, onMove);
			removeEventListener(SpaceBodyEvent.ON_CRASH, onCrash);
			removeEventListener(SpaceBodyEvent.ON_REBORN, onReBorn);
		}
		
		/**
		 * Handles reappearence of spacebody
		 * @param evt Event
		 * 
		 */		
		protected function onCrash(evt:Event):void {
			/*implement
			play sound, dissapper, fire to reborn
			*/
			var that:SpaceBody = this;
			var _interval:uint;
			loader.alpha = 0.2;
			
			// destroy the body after a sec
			_interval = setInterval(function():void {
				visible = false;
				__unload();
				clearInterval(_interval);
				// create the body after a sec, fire the event
				_interval = setInterval(function():void {
					dispatchEvent(SpaceBodyEvent.getInstance(SpaceBodyEvent.ON_REBORN))
					clearInterval(_interval);
				}, 1000);
			}, 1000);
		}
		
		/**
		 * Embed image using loader, adjust position
		 * @param e Event
		 * 
		 */		
		protected function onLoaderReady(evt:Event):void {
			if(loader) {
				Bitmap(loader.content).smoothing = true;
				loader.x = -_imgMaskPosition.x - Math.round(this.mask.width/2);
				loader.y = -_imgMaskPosition.y - Math.round(this.mask.height/2);
			}
		}
		
		protected function onMove(evt:Event):void {
			/*implement onChangePosition()
			and nofityPosition()
			
			general method for moving
			play sound?
			*/
		}
		
		protected function onReBorn(evt:Event):void {
			// for implementation
		}
	}
}