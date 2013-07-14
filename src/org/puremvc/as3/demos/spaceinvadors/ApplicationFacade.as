package org.puremvc.as3.demos.spaceinvadors  {
	
	import org.puremvc.as3.demos.spaceinvadors.controller.StartupCommand;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade {
		
		public static const STARTUP:String = "startup";
		
		/**
		 * Singleton
		 * @return ApplicationFacade
		 * 
		 */		
		public static function getInstance(): ApplicationFacade {
			if (instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		/**
		 * Inititalizes controller, regoster Startup command
		 * 
		 */		
		protected override function initializeController():void {
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);	
		}
		
		/**
		 * Send notification for application startup 
		 * @param app
		 * 
		 */		
		public function startup(app:SpaceInvadors):void {
			sendNotification(STARTUP, app);
		}
	}
}