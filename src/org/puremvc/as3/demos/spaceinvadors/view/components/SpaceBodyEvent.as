package org.puremvc.as3.demos.spaceinvadors.view.components {
	
	import flash.events.Event;
	
	public class SpaceBodyEvent extends Event
	{
		public static const ON_CRASH:String = "onCrash";
		
		public static const ON_MOVE:String = "onMove";
		
		public static const ON_REBORN:String = "onReborn";
		
		private static var instance:Array = [];
		
		function SpaceBodyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
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