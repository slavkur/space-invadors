package org.puremvc.as3.demos.spaceinvadors.view {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.demos.spaceinvadors.view.components.Attacker;
	import org.puremvc.as3.demos.spaceinvadors.view.components.AttackerEvent;
	import org.puremvc.as3.demos.spaceinvadors.view.components.Bullet;
	import org.puremvc.as3.demos.spaceinvadors.view.components.Pilot;
	import org.puremvc.as3.demos.spaceinvadors.view.components.SpaceBodyEvent;
	import org.puremvc.as3.demos.spaceinvadors.view.components.Specie;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator {
		
		private var _interval:uint;
		
		public function get app():SpaceInvadors { 
			return viewComponent as SpaceInvadors;
		}
		
		private static var attackers:Array = [];
		
		private var battlefield:Sprite;
		
		[Embed(source = "settings.xml", mimeType="application/octet-stream")]
		private static var Settings:Class;
		
		protected const settings:XML = _settings();
		
		public static const NAME:String	= "ApplicationMediator";
		
		public function ApplicationMediator(viewComponent:SpaceInvadors) {
			super(NAME, viewComponent);
		}
		
		/**
		 * Read and load XML for global settings
		 * @return XML
		 * 
		 */		
		public static function _settings():XML {
			var file:ByteArray = new Settings();
			var str:String = file.readUTFBytes(file.length);
			return new XML(str);
		}
		
		/**
		 * Unsign attacker from the array
		 * @param attacker Attacker
		 * 
		 */		
		private function __unsignDestroyedAttacker(attacker:Attacker):void {
			attacker.addEventListener(SpaceBodyEvent.ON_CRASH, function(evt:Event):void {
				var index:int = attackers.indexOf(evt.currentTarget as Attacker);
				delete attackers[index];
				attackers.splice(index, 1);
				if(attackers.length == 1 && getDefinitionByName(getQualifiedClassName(attackers[0])) == Pilot) {
					var victorySound:Sound = new Sound(new URLRequest(settings.theme.sound.victory.@src));
					var _interval:uint = setInterval(function():void {
						createSpecies();
						clearInterval(_interval);
					}, 1000);
					victorySound.play();
				}
			});
		}
		
		/**
		 * Collect all attackers including pilot into one array 
		 */		
		private function createAttackers():void {
			battlefield = new Sprite();
			createSpecies();
			createPilot();
		}
		
		/**
		 * Create only one pilot, assign events for keyboard
		 * @param evt
		 * 
		 */		
		private function createPilot(evt:Event = null):void {
			var stage:Stage = app.stage;
			var pilot:Pilot = new Pilot();
			pilot.y = 180;
			pilot.x = (stage.stageWidth/4);
			// give the bullet to pilot
			pilot.addEventListener(AttackerEvent.ON_SHOOT, triggerBullet, false, 0, true);
			pilot.addEventListener(SpaceBodyEvent.ON_REBORN, createPilot, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pilot.keyDownListener, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, pilot.keyUpListener, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, pilot.mouseMoveListener, false, 0, true);
			stage.addEventListener(MouseEvent.CLICK, pilot.mouseClickListener, false, 0, true);
			pilot.addEventListener(SpaceBodyEvent.ON_CRASH, function(evt:Event):void {
				evt.currentTarget.removeEventListener(AttackerEvent.ON_SHOOT, triggerBullet);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, pilot.keyDownListener);
				stage.removeEventListener(KeyboardEvent.KEY_UP, pilot.keyUpListener);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, pilot.mouseMoveListener);
				stage.removeEventListener(MouseEvent.CLICK, pilot.mouseClickListener);
				pilot = null;
			});
			
			attackers.push(pilot);
			__unsignDestroyedAttacker(pilot as Attacker);
			
			battlefield.addChild(pilot);
		}
		
		/**
		 * Create 3 rows of 10 species
		 * Random shoots for species
		 */		
		private function createSpecies():void {
			var species:Array = [];
			var specieWidth:int = 0;
			var specieHeight:int = 0;
			
			// for 3 rows
			for(var r:int = 0; r < 3; r++) {
				// create 10 columns
				for(var c:int = 0; c < 10; c++) {
					var specie:Specie = new Specie();
					specie.y = 10;
					if(species.length > 1) {
						if(r > 0) {
							// continue distributing species on corresponding row
							specie.y = species[r * 10 - 1].y + specie.mask.height * (1 + 4/5) + 20;
							// refer position for x-axis to species on row before
							specie.x = species[(r-1) * 10 + c].x;
						} else {
							// keep specie positioned on the line, not overlap
							specie.x = species[c + r * 10 - 1].x + specie.mask.width * (1 + 4/5);
						}
					}
					specie.beginManeuver();
					specieWidth += specie.mask.width;
					specieHeight += specie.mask.height;
					specie.addEventListener(AttackerEvent.ON_SHOOT, triggerBullet, false, 0, true);
					specie.addEventListener(SpaceBodyEvent.ON_CRASH, function(evt:Event):void {
						evt.currentTarget.removeEventListener(AttackerEvent.ON_SHOOT, triggerBullet);
						specie = null;
					});
					__unsignDestroyedAttacker(specie as Attacker);
					
					species.push(specie);
					battlefield.addChild(specie);
				}
			}
			
			/*
			make species shoot randomly
			*/
			clearInterval(_interval);
			_interval = setInterval(function():void {
				// pick random specie for array
				if(species.length > 0) {
					var randspecie:Specie = species[Math.floor(Math.random() * species.length)];
					randspecie.beginShoot();
				}
			}, 1000);
			
			// update attackers with species
			attackers = attackers.concat(species);
		}
		
		/**
		 * Only place where Bullet is created
		 * Triggered by attacker
		 */
		public function triggerBullet(evt:Event):void {
			var bullet:Bullet = new Bullet();
			
			bullet.addEventListener(SpaceBodyEvent.ON_MOVE, onTriggerBullet, false, 0, true);
			bullet.addEventListener(SpaceBodyEvent.ON_CRASH, function(evt:Event):void {
				evt.currentTarget.removeEventListener(SpaceBodyEvent.ON_MOVE, onTriggerBullet);
				evt.currentTarget.__unload();
			});
			bullet.beginMoving(evt.currentTarget as Attacker);
			
			// boolets escaped from the removal, should not be any
			/*			if(attackers.indexOf(bullet.attacker) == -1) {
			trace(bullet.x, bullet.y, bullet.attacker, attackers.indexOf(bullet.attacker));
			bullet.removeEventListener(AttackerEvent.ON_SHOOT, triggerBullet);
			bullet.__unload();
			bullet = null;
			return;
			}*/
			
			battlefield.addChild(bullet);
		}
		
		/**
		 * Register components 
		 * 
		 */		
		override public function onRegister():void {
			createAttackers();
			app.outputComponent = battlefield;
		}
		
		/**
		 * The bullet is released, for each enemy around check positions
		 * for possible hit 
		 * @param evt SpaceBodyEvent
		 * 
		 */		
		public function onTriggerBullet(evt:Event):void {
			//Bulletevt.currentTarget.removeEventListener(SpaceBodyEvent.ON_MOVE, onTriggerBullet);
			for each(var attacker:Attacker in attackers) {
				evt.currentTarget.destroyOrEscape(attacker);
			}
		}
	}
}