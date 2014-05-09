/**
 * PushButton.as
 * Keith Peters
 * version 0.9.10
 * 
 * A basic button component with a label.
 * 
 * Copyright (c) 2011 Keith Peters
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
 
package com.bit101.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;

	public class PushButton extends Component
	{
		protected var _back:Sprite;
		protected var _face:Sprite;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _over:Boolean = false;
		protected var _down:Boolean = false;
		protected var _selected:Boolean = false;
		protected var _toggle:Boolean = false;
		//实际使用的皮肤
		protected var _defaultSkin:Bitmap;
		protected var _downSkin:Bitmap;
		protected var _overSkin:Bitmap;
		//默认的皮肤bmd
		protected var _defaultSkinData:BitmapData;
		protected var _downSkinData:BitmapData;
		protected var _overSkinData:BitmapData;
		protected var _skinSp:Sprite;
		protected var _isSkin:Boolean;
		protected var _sizeNoScale:Boolean;
		protected var _stateNum:int;//状态的个数
		protected var _textFormate:TextFormat;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this PushButton.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label The string to use for the initial label of this component.
 		 * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
		 */
		public function PushButton(label:String = "", defaultHandler:Function = null,overHandler:Function=null)
		{
			if(defaultHandler != null)
			{
				addEventListener(MouseEvent.CLICK, defaultHandler);
			}
			if(overHandler != null)
			{
				addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			}
			this._labelText = label;//原来this._label= label;触发draw
			this.addEventListener(Event.ADDED_TO_STAGE,onadded);
			super();
		}
		
		public function onadded(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,onadded);
			this.addChildren();
			this.draw();
		}
		
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			//super.init();
			_back = new Sprite();
			_face = new Sprite();
			_skinSp = new Sprite;
			_label = new Label();
			buttonMode = true;
			useHandCursor = true;
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 * 不能在此处实例  此处只在添加到舞台才调用
		 */
		override protected function addChildren():void
		{
			if(!_isSkin)
			{
				setSize(100, 20);
				_back.filters = [getShadow(2, true)];
				_back.mouseEnabled = false;
				addChild(_back);
				
				_face.mouseEnabled = false;
				_face.filters = [getShadow(1)];
				_face.x = 1;
				_face.y = 1;
				addChild(_face);
			}
			else {
				addChild(_skinSp);
				_skinSp.addChild(this._defaultSkin);
				if(this._width==0||this._height==0)
				setSize(_defaultSkin.width,_defaultSkin.height);
			}
			
			addChild(_label);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
		}
		
		/**
		 * Draws the face of the button, color based on state.
		 */
		protected function drawFace():void
		{
			if(!_isSkin){
				_face.graphics.clear();
				if(_down)
				{
					_face.graphics.beginFill(Style.BUTTON_DOWN);
				}
				else
				{
					_face.graphics.beginFill(Style.BUTTON_FACE);
				}
				_face.graphics.drawRect(0, 0, _width - 2, _height - 2);
				_face.graphics.endFill();
			}
			else {
				if(_skinSp.width!=_width||_skinSp.height!=_height)
				changeSize();
				changeState();
			}
		}
		
		private function changeSize():void{
			if(_sizeNoScale){//此处是不拉伸的情况下进行大小改变
				if(_defaultSkin){
					_defaultSkin.bitmapData = _defaultSkinData;
					changeSizeNoScale(_defaultSkin);
				}
				if(_downSkin){
					_downSkin.bitmapData = _downSkinData;
					changeSizeNoScale(_downSkin);
				}
				if(_overSkin){
					_overSkin.bitmapData = _overSkinData;
					changeSizeNoScale(_overSkin);
				}
			}
			else {
				_skinSp.width =_width;
				_skinSp.height =_height;
			}
		}
		
		private function changeState():void{
			if(_down&&_downSkin){
				_skinSp.removeChildren();
				_skinSp.addChild(_downSkin);
			}
			else if(_over&&_overSkin){
				_skinSp.removeChildren();
				_skinSp.addChild(_overSkin);
			}
			else{
				_skinSp.removeChildren();
				_skinSp.addChild(_defaultSkin);
			}
		}
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			
			//没有皮肤用绘图
			if(!_isSkin){
				_back.graphics.clear();
				_back.graphics.beginFill(Style.BACKGROUND);
				_back.graphics.drawRect(0, 0, _width, _height);
				_back.graphics.endFill();
			}
			
			
			drawFace();
			
			_label.text = _labelText;
			_label.autoSize = true;
			_label.draw();
			if(_label.width > _width - 4)
			{
				_label.autoSize = false;
				_label.width = _width - 4;
			}
			else
			{
				_label.autoSize = true;
			}
			_label.draw();
			_label.move(_width / 2 - _label.width / 2, _height / 2 - _label.height / 2);
			
		}
		
		
		public function allSkin(bm:Bitmap,num:int = 4):void{
			if(!bm) return;
			if(num<1||num>4) num = 4;
			_stateNum = num;
			_isSkin = true;
			
			var point:Point = new Point(0, 0);
			if(num>=2){
				_defaultSkin = new Bitmap();
				_defaultSkin.bitmapData = new BitmapData(bm.width/num, bm.height);
				_defaultSkin.bitmapData.copyPixels(bm.bitmapData,new Rectangle(0 , 0, bm.width/num, bm.height),point);
				_defaultSkinData = _defaultSkin.bitmapData;
			}
			if(num>=2){
				_downSkin = new Bitmap();
				_downSkin.bitmapData = new BitmapData(bm.width/num, bm.height);
				_downSkin.bitmapData.copyPixels(bm.bitmapData,new Rectangle(bm.width/num , 0, bm.width/num, bm.height),point);
				_downSkinData = _downSkin.bitmapData;
			}
			if(num>=3){
				_overSkin = new Bitmap();
				_overSkin.bitmapData = new BitmapData(bm.width/num, bm.height);
				_overSkin.bitmapData.copyPixels(bm.bitmapData,new Rectangle(bm.width/num * 2 , 0, bm.width/num, bm.height),point);
				_overSkinData = _overSkin.bitmapData;
			}
			
		}
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseOver handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOver(event:MouseEvent):void
		{
			_over = true;
			this.drawFace();
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			if(_isSkin){
				this.drawFace();
			}
			else if(!_down)
			{
				_face.filters = [getShadow(1)];
			}
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		/**
		 * Internal mouseOut handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			_down = true;
			drawFace();
			if(!_isSkin)
			{
				_face.filters = [getShadow(1, true)];
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		/**
		 * Internal mouseUp handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			if(_toggle  && _over)
			{
				_selected = !_selected;
			}
			_down = _selected;
			drawFace();
			if(!_isSkin)
			{
				_face.filters = [getShadow(1, _selected)];
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the label text shown on this Pushbutton.
		 */
		public function set label(str:String):void
		{
			_labelText = str;
			draw();
		}
		public function get label():String
		{
			return _labelText;
		}
		
		public function set selected(value:Boolean):void
		{
			if(!_toggle)
			{
				value = false;
			}
			
			_selected = value;
			_down = _selected;
			_face.filters = [getShadow(1, _selected)];
			drawFace();
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set toggle(value:Boolean):void
		{
			_toggle = value;
		}
		public function get toggle():Boolean
		{
			return _toggle;
		}

		//设置皮肤
		public function set defaultSkin(value:Bitmap):void
		{
			_isSkin = true;
			_defaultSkinData = value.bitmapData;
			_stateNum = 0;
			_stateNum++;
			var point:Point = new Point();
			_defaultSkin = new Bitmap();
			_defaultSkin.bitmapData = new BitmapData(value.width,value.height);
			_defaultSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
		}

		public function set downSkin(value:Bitmap):void
		{
			_downSkinData = value.bitmapData;
			_stateNum++;
			var point:Point = new Point();
			_downSkin = new Bitmap();
			_downSkin.bitmapData = new BitmapData(value.width,value.height);
			_downSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
		}

		public function set overSkin(value:Bitmap):void
		{
			_overSkinData = value.bitmapData;
			_stateNum++;
			var point:Point = new Point();
			_overSkin = new Bitmap();
			_overSkin.bitmapData = new BitmapData(value.width,value.height);
			_overSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
		}

		public function get sizeNoScale():Boolean
		{
			return _sizeNoScale;
		}

		public function set sizeNoScale(value:Boolean):void
		{
			_sizeNoScale = value;
			this.invalidate();
		}

		public function get textFormate():TextFormat
		{
			return _textFormate;
		}

		public function set textFormate(value:TextFormat):void
		{
			_label.textFormate = value;
			_textFormate = value;
		}
		
		
	}
}