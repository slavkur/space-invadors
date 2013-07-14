package {		import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import org.puremvc.as3.demos.spaceinvadors.ApplicationFacade;
	
	/**
	 * The main application.	 */	[SWF(width="200", height="200", frameRate="31", backgroundColor="#000000")]	public class SpaceInvadors extends Sprite {				/**		 * Set the output display component.		 * @param output Sprite		 */		public function set outputComponent(output:Sprite):void {			output.x = stage.width / 2 + 30;			output.y = 10;			stage.addChild(output);		}				public function SpaceInvadors() {			init();			/*			load image from lib			*/						///////////////////////////////////			var sprite: Sprite = new Sprite();			var g: Graphics = sprite.graphics;			g.lineStyle(1);			g.beginFill(0x111111, 1);			g.drawRect(0, 0, stage.stageWidth, stage.stageHeight);			g.endFill();			addChild(sprite);			//////////////////////////////////		}				/**		 * Initialize the application.		 */		public function init():void {			var facade:ApplicationFacade = ApplicationFacade.getInstance();			stage.scaleMode	= StageScaleMode.NO_SCALE;			stage.align	= StageAlign.TOP_LEFT;						facade.startup(this);		}	}}