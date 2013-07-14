package org.puremvc.as3.demos.spaceinvadors.controller  {
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.demos.spaceinvadors.view.ApplicationMediator;
	
	public class StartupCommand extends SimpleCommand {
		/**
		 * Execute the business logic. Register application mediator
		 */
		override public function execute(note:INotification):void {
			var app:SpaceInvadors = note.getBody() as SpaceInvadors;
			facade.registerMediator(new ApplicationMediator(app));
		}
	}
}