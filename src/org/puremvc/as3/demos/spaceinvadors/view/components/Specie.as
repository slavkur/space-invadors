package org.puremvc.as3.demos.spaceinvadors.view.components {
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Strong;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	public class Specie extends Attacker {
		/**
		 * Position of the image in the mask
		 * @return Point
		 */
		protected override function get _imgMaskPosition():Point {
			return new Point(Number(settings.theme.specie.@x),
							 Number(settings.theme.specie.@y));
		}
		
		/**
		 * Helps bullet to be positioned nicely in front of barrel
		 * @return Point
		 * 
		 */	
		public override function get bulletPosition():Point {
			return new Point(x + mask.width / 2 - 5, y + mask.height + 8);
		}
		
		public function Specie()
		{
			super();
			/*
			load image 
			_images/specie.gif
			*/
			_createMask(Number(settings.theme.specie.@width),
					    Number(settings.theme.specie.@height));
		}
		
		/**
		 * Slide species from left to right 
		 * 
		 */		
		public function beginManeuver():void {
			var that:Specie = this;
			var limit:Number = 10;
			var started:Number = -limit;
			var step:Number = 1;
			setInterval(function():void {
				if(started < limit) {
					started += Math.abs(step);
					x += step;
				} else {
					started = -started;
					step = -step;
				}
			}, Number(settings.specie.@maneuverInterval));
		}
		
		/**
		 * Called when specie crashes 
		 * @param evt 
		 * 
		 */		
		override protected function onCrash(evt:Event):void {
			super.onCrash(evt);
			var crashSound:Sound = new Sound(new URLRequest(settings.theme.specie.sound.crash.@src));
			crashSound.play();
			/*
			change the mask to position of crashed image
			*/
			// mask position
			// reborn
		}
	}
}