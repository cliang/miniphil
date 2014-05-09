package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Window;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import lzm.starling.STLStarup;
	
	import starling.core.Starling;
	
	[SWF( width="960", height="560",frameRate="60",backgroundColor="#FFFF88")]
	public class featherTest extends STLStarup
	{
		[Embed(source = "btn2.png")]
		private var Btn:Class;
		[Embed(source = "btn0.png")]
		private var Back:Class;
		[Embed(source = "btn.png")]
		private var Title:Class;
		[Embed(source = "btnClose.png")]
		private var BtnClose:Class;
		[Embed(source = "arrow.png")]
		private var Arrow:Class;
		[Embed(source = "gou.png")]
		private var Gou:Class;
		[Embed(source = "back.png")]
		private var Back2:Class;
		
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
			//Style.BACKGROUND = 0xFF0000;  
			//Style.BUTTON_FACE = 0xCCCCFF;  
			Style.LABEL_TEXT = 0xFF0000;
			
			btn = new PushButton("测adsgadgadgadgagasd试",mouseHandler);  
			btn.move(stage.stageWidth >> 1,stage.stageHeight >> 1);
			btn.allSkin(new Btn as Bitmap,4);
			btn.sizeNoScale = true;
			btn.setSize(200,100);
			this.addChild(btn);
			
			//var acc:Accordion = new Accordion(stage,100,100);
			//acc.panelSkin = new Back as Bitmap;
			
			var panel:Panel = new Panel();
			panel.sizeNoScale = true;
			panel.width = 100;
			panel.height = 100;
			panel.backgroundSkin = new Back as Bitmap;
			addChild(panel);
			
			var window:Window = new Window("jadga");
			window.move(500,50);
			window.contantPanelSkin = new Back as Bitmap;//
			window.titlePanelSkin = new Title as Bitmap;//
			window.gripsVisible = true;
			window.draggable = true;
			window.hasCloseButton = true;
			window.hasMinimizeButton = true;
			window.minimizeSkin = new Arrow as Bitmap;
			window.allCloseButtonSkin(new BtnClose as Bitmap);
			window.addEventListener(Event.SELECT, mouseHandler);
			addChild(window);
			window.closeButton.sizeNoScale = true;
			//window.minimized = true;
			
			var checkBox:CheckBox  = new CheckBox("好的",mouseHandler);
			checkBox.move(20,300);
			checkBox.setSize(200,100);
			checkBox.backSkin = new Back2 as Bitmap;
			checkBox.buttonSkin = new Gou as Bitmap;
			addChild(checkBox);
		}
		
		private function mouseHandler(e):void  
		{  
			trace("aisajiajiao");  
		}
		
	}
}