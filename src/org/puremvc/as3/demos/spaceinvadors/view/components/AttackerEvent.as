package org.puremvc.as3.demos.spaceinvadors.view.components {
	
	import flash.events.Event;
	
	public class AttackerEvent extends SpaceBodyEvent {
		
		public static const ON_MOVE_LEFT:String = "onMoveLeft";
		
		public static const ON_MOVE_RIGHT:String = "onMoveRight";
		
		public static const ON_SLIDE_LEFT:String = "onSlideLeft";
		
		public static const ON_SLIDE_RIGHT:String = "onSlideRight";
		
		public static const ON_SHOOT:String = "onShoot";
		
		private static var instance:Array = [];
		
		function AttackerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Implements constractor, returns only one instance that already registered
		 */		
		public static function getInstance(type:String, bubbles:Boolean=false, cancelable:Boolean=false):Event {
			if (instance[type] == null) instance[type] = new Event(type, bubbles, cancelable);
			return instance[type];
		}
	}
}