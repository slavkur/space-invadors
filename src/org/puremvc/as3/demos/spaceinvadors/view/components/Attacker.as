package org.puremvc.as3.demos.spaceinvadors.view.components {
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Attacker extends SpaceBody	{
		/**
		 * Helps bullet to be positioned nicely in front of barrel
		 * @return Point
		 * 
		 */				
		public function get bulletPosition():Point {
			return new Point(0, 0);
		}
		
		/**
		 * Override 
		 * @return int Direction of the bullet along the y-axis
		 * 
		 */		
		public function get bulletYDirection():int {
			return 1;
		}
		
		public function Attacker()
		{
			super();
			/*
			KeyListener shoot 
			*/
			addEventListener(AttackerEvent.ON_SHOOT, onShoot, false, 0, true);
			trace(settings.theme.sound.shoot.@src)
			
		}
		
		/**
		 * Unsign attacker's listeners   
		 */
		public override function __unload():void {
			super.__unload();
			removeEventListener(AttackerEvent.ON_SHOOT, onShoot);
		}
		
		/**
		 * implement this method for triggering bullet movement
		 * 
		 */		
		public function beginShoot():void {
			dispatchEvent(AttackerEvent.getInstance(AttackerEvent.ON_SHOOT));
		}
		
		/**
		 * 
		 * @param evt Event
		 * 
		 */		
		protected function onShoot(evt:Event):void {
			/*implement
			
			continuation event catched with KEY.SPACE
			use of sound, bulet
			
			create a bulet not in the bounds with attacker
			set the period before new bulet can come out
			*/	
		}
	}
}