package
{
	import com.bit101.components.Accordion;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import lzm.starling.STLStarup;
	
	import starling.core.Starling;
	
	[SWF( width="960", height="560",frameRate="60",backgroundColor="#FFFF88")]
	public class featherTest extends STLStarup
	{
		[Embed(source = "btn2.png")]
		private var Btn:Class;
		[Embed(source = "btn0.png")]
		private var Back:Class;
		
		
		private var myStarling:Starling;   
		
		private var btn:PushButton; 
		
		public function featherTest()
		{
			//myStarling = new Starling(Main, stage);
			//myStarling.showStats = true;
			//myStarling.antiAliasing = 1;   
			//myStarling.enableErrorChecking = true;
			//myStarling.start();
			
			addEventListener(Event.ADDED_TO_STAGE,onadded);
		}
		
		private function onadded(e:Event):void
		{
			Style.fontSize = 12;  
			//要使用中文就要将嵌入字体设为false  
			Style.embedFonts = false;  
			Style.BACKGROUND = 0xFF0000;  
			Style.BUTTON_FACE = 0xCCCCFF;  
			Style.LABEL_TEXT = 0xFF0000;
			
			btn = new PushButton("测adsgadgadgadgagasd试",mouseHandler);  
			btn.move(stage.stageWidth >> 1,stage.stageHeight >> 1);
			btn.allSkin(new Btn as Bitmap,4);
			btn.sizeNoScale = true;
			btn.width = 430;
			btn.height = 206;
			this.addChild(btn);
			
			var acc:Accordion = new Accordion(stage,100,100);
			acc.panelSkin = new Back as Bitmap;
			
			var panel:Panel = new Panel();
			panel.sizeNoScale = true;
			panel.width = 300;
			panel.height = 300;
			panel.backgroundSkin = new Back as Bitmap;
			addChild(panel);
			
			var window:Window = new Window(this,500,50,"jhehehsadga");
			//window.panelSkin = this._panelSkin;
			window.grips.visible = false;
			window.draggable = false;
			window.addEventListener(Event.SELECT, mouseHandler);
			//window.minimized = true;
		}
		
		private function mouseHandler(e):void  
		{  
			trace("aisajiajiao");  
		}
		
	}
}