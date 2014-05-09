package 
{
	import flash.display.Bitmap;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import lzm.starling.STLMainClass;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Main extends STLMainClass
	{
		[Embed(source = "btn0.png")]
		private var Btn:Class;
		private var image:Image;
		protected var theme:MetalWorksMobileTheme;
		protected var button:Button;
		
		public function Main()
		{
			image = new Image(Texture.fromBitmap(new Btn as Bitmap));
			addEventListener(Event.ADDED_TO_STAGE,onadded);
		}
		
		private function onadded(e:Event):void
		{
			this.theme = new MetalWorksMobileTheme( this.stage );
			var button:Button = new Button();
			button.label = "Click Me";
			button.addEventListener( Event.TRIGGERED, button_triggeredHandler );
			this.addChild( button );
			button.defaultSkin = image;
			button.downSkin = image
			button.x = 200;
			button.y = 300;
			//button.defaultIcon = image
			button.iconPosition = Button.ICON_POSITION_TOP;
		}
		
		private function button_triggeredHandler( event:Event ):void
		{
			var button:Button = Button( event.currentTarget );
			var content:Image = image;
			var callout:Callout = Callout.show( content,button );
			callout.supportedDirections = Callout.DIRECTION_LEFT;
		}
	}
}