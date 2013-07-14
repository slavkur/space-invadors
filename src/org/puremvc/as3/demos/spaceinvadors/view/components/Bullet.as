package org.puremvc.as3.demos.spaceinvadors.view.components
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;
	
	public class Bullet extends SpaceBody
	{
		/**
		 * Position of the image in the mask
		 * @return Point
		 */
		protected override function get _imgMaskPosition():Point {
			return new Point(Number(settings.theme.bullet.@x),
							 Number(settings.theme.bullet.@y));
		}

		private var _interval:uint;
		
		public var attacker:Attacker;
		
		
		public function Bullet()
		{
			super();
			/*
			applying mask
			*/
			_createMask(Number(settings.theme.bullet.@width),
					    Number(settings.theme.bullet.@height));
		}
		
		/**
		 * Unload extra actions for bullet
		 * 
		 */		
		public override function __unload():void {
			super.__unload();
			clearInterval(_interval);
		}
		
		/**
		 * Assigning attacker for a bullet
		 * @param attacker Attacker
		 * 
		 */		
		public function beginMoving(attacker:Attacker):void {
			var that:Bullet = this;
			if(getDefinitionByName(getQualifiedClassName(attacker)) != Pilot)
				var shooterSound:Sound = new Sound(new URLRequest(settings.theme.bullet.sound.shoot.@src));
				if(shooterSound)
					shooterSound.play();
				
			this.attacker = attacker;
			this.x = attacker.bulletPosition.x;
			this.y = attacker.bulletPosition.y;
			_interval = setInterval(function():void {
				/*
				* Saving memory, unload bullet that escaped
				*/
				if(y + mask.height < stage.y || y + mask.height > stage.y + stage.height) {
					__unload.call(that);
					return;
				}
				y += attacker.bulletYDirection;
				// propogate about its movement
				dispatchEvent(SpaceBodyEvent.getInstance(SpaceBodyEvent.ON_MOVE) as Event);
			}, Number(settings.bullet.@interval));
		}
		
		/**
		 * Checks whether this bullet has reached enemy's body
		 * if they are in the same bounds kill the enemy
		 * Differs body types, does not kill same kind of bodies like Species
		 * @param attacker Attacker
		 * 
		 */		
		public function destroyOrEscape(attacker:Attacker):void {
			/*
			receives position of the attacker and check its own
			call onCrash event
			*/
			
			if(attacker != this.attacker && 
				getDefinitionByName(getQualifiedClassName(this.attacker)) 
					!= getDefinitionByName(getQualifiedClassName(attacker)) as Class &&
				mask.hitTestObject(attacker.mask)) {
				/*
				Saving memory, unload bullet that crashed
				dispatch on crash events 
				*/
				attacker.dispatchEvent(SpaceBodyEvent.getInstance(SpaceBodyEvent.ON_CRASH));
				dispatchEvent(SpaceBodyEvent.getInstance(SpaceBodyEvent.ON_CRASH));
				__unload();
				return;
			}
		}
	}
}