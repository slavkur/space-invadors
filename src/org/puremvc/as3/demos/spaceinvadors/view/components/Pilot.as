package org.puremvc.as3.demos.spaceinvadors.view.components {
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	public class Pilot extends Attacker {
		/**
		 * Position of the image in the mask
		 * @return Point
		 * 
		 */
		protected override function get _imgMaskPosition():Point {
			return new Point(Number(settings.theme.pilot.@x),
							 Number(settings.theme.pilot.@y));
		}
		
		/**
		 * Helps bullet to be positioned nicely in front of barrel
		 * @return Point
		 * 
		 */	
		public override function get bulletPosition():Point {
			return new Point(x + (mask.width / 2) - 5, y - 8);
		}
		
		/**
		 * Defines direction of the bullet along y-axis 
		 * @return int
		 * 
		 */
		public override function get bulletYDirection():int {
			return -1;
		}
		
		protected var shooterSound:Sound;

		public function Pilot()
		{
			super();
			/*
			load image
			_images/pilot.gif
			*/
			/*
			KeyListener shoot 
			*/
			addEventListener(AttackerEvent.ON_MOVE_LEFT, onMoveLeft, false, 0, true);
			addEventListener(AttackerEvent.ON_MOVE_RIGHT, onMoveRight, false, 0, true);
			addEventListener(AttackerEvent.ON_SLIDE_LEFT, onSlideLeft, false, 0, true);
			addEventListener(AttackerEvent.ON_SLIDE_RIGHT, onSlideRight, false, 0, true);
			
			/*
			applying mask
			*/
			_createMask(Number(settings.theme.pilot.@width),
				        Number(settings.theme.pilot.@height));
			
			shooterSound = new Sound(new URLRequest(settings.theme.pilot.sound.shoot.@src));
		}
		
		/**
		 * Unsign pilot's listeners
		 * 
		 */
		public override function __unload():void {
			super.__unload();
			removeEventListener(AttackerEvent.ON_MOVE_LEFT, onMoveLeft);
			removeEventListener(AttackerEvent.ON_MOVE_RIGHT, onMoveRight);
		}
		
		/**
		 * Plays sound on shoot event
		 * 
		 */		
		public override function beginShoot():void {
			super.beginShoot();
			shooterSound.play();
		}
		
		/**
		 * Register on events when key is down  
		 * @param e KeyboardEvent
		 * 
		 */		
		public function keyDownListener(evt:KeyboardEvent):void {
			switch(evt.keyCode){
				case Keyboard.LEFT:
					dispatchEvent(AttackerEvent.getInstance(AttackerEvent.ON_MOVE_LEFT));
					break;
				case Keyboard.RIGHT:
					dispatchEvent(AttackerEvent.getInstance(AttackerEvent.ON_MOVE_RIGHT));
					break;
				case Keyboard.SPACE:
					beginShoot();
					break;
			}
		}
		
		/**
		 * Register on events when key is up 
		 * @param e KeyboardEvent
		 * 
		 */		
		public function keyUpListener(evt:KeyboardEvent):void {
			switch(evt.keyCode){
				case Keyboard.LEFT:
					dispatchEvent(AttackerEvent.getInstance(AttackerEvent.ON_SLIDE_LEFT));
					break;
				case Keyboard.RIGHT:
					dispatchEvent(AttackerEvent.getInstance(AttackerEvent.ON_SLIDE_RIGHT));
					break;
			}
		}
		
		/**
		 * When mouse is present at the stage ship follows it on x-axis
		 * @param e KeyboardEvent
		 * 
		 */		
		public function mouseMoveListener(evt:MouseEvent):void {
			x = evt.localX;
		}
		
		/**
		 * On mouse click the shoot will start 
		 * @param e KeyboardEvent
		 * 
		 */		
		public function mouseClickListener(evt:MouseEvent):void {
			beginShoot();
		}
		
		/**
		 * Called when pilot crashes 
		 * @param evt 
		 * 
		 */		
		override protected function onCrash(evt:Event):void {
			super.onCrash(evt);
			var crashSound:Sound = new Sound(new URLRequest(settings.theme.pilot.sound.crash.@src));
			crashSound.play();
			/*
			life minus 1
			change the mask to position of crashed image
			*/
			// mask position
			// reborn
		}
		
		/**
		 * Continuation event catched with Keyboard.LEFT
		 * Changes the position x-left
		 * @param evt AttackerEvent
		 * 
		 */		
		protected function onMoveLeft(evt:Event):void {
			onSlideLeft(evt);
			x -= Number(settings.pilot.@maneuverSpeed);
		}
		
		/**
		 * Continuation event catched with Keyboard.LEFT
		 * changes the position x-right
		 * @param evt AttackerEvent
		 * 
		 */		
		protected function onMoveRight(evt:Event):void {
			onSlideRight(evt);
			x += Number(settings.pilot.@maneuverSpeed);
		}
		
		/**
		 * Minor slide effect after keyboard button is released 
		 * @param evt
		 * 
		 */		
		protected function onSlideLeft(evt:Event):void {
			TweenLite.to(this, Number(settings.pilot.@slideInterval),
				{ease:Back.easeOut,
				 x: this.x - Number(settings.pilot.@slideLength)});
		}
		
		/**
		 * Minor slide effect after keyboard button is released 
		 * @param evt
		 * 
		 */		
		protected function onSlideRight(evt:Event):void {
			TweenLite.to(this, Number(settings.pilot.@slideInterval),
				{ease:Back.easeOut,
				 x: this.x + Number(settings.pilot.@slideLength)});
		}
	}
}