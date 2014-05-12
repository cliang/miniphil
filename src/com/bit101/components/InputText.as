/**
 * InputText.as
 * Keith Peters
 * version 0.9.10
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
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class InputText extends Component
	{
		protected var _back:Sprite;
		protected var _password:Boolean = false;
		protected var _text:String = "";
		protected var _tf:TextField;
		protected var _boxSkin:Bitmap;
		protected var _boxSkinData:BitmapData;
		protected var _hasSkin:Boolean;
		protected var _defaultHandler:Function;
		protected var _sizeNoScale:Boolean;
		protected var _showMode:String;
		protected var _changeByTextheight:Boolean = true;//外框的高度更随文字的高度改变   在_showMode为多行的时候可用
		protected var _defaultHeight:int;
		
		public static var ONELINE:String = "oneline";//单行输入
		public static var WRAPLINE:String = "wrapline";//多行输入（自动换行）
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this InputText.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param text The string containing the initial text of this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function InputText(text:String = "", defaultHandler:Function = null)
		{
			this.text = text;
			_defaultHandler = defaultHandler;
			this.addEventListener(Event.ADDED_TO_STAGE,onadded);
		}
		
		private function onadded(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,onadded);
			this.addChildren();
			this.draw();
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			_back = new Sprite();
			_tf = new TextField();
		}
		
		/**
		 * Creates and adds child display objects.
		 */
		override protected function addChildren():void
		{
			if(_defaultHandler != null)
			{
				addEventListener(Event.CHANGE, _defaultHandler);
			}
			
			if(this._hasSkin == false)
				this.setSize(100,16);
			else if(this._width==0||this._height==0)
				this.setSize(_boxSkin.width,_boxSkin.height);
			_defaultHeight = height;
			
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_tf.embedFonts = Style.embedFonts;
			_tf.selectable = true;
			_tf.type = TextFieldType.INPUT;
			_tf.defaultTextFormat = new TextFormat(Style.fontName, Style.fontSize, Style.INPUT_TEXT);
			addChild(_tf);
			_tf.addEventListener(Event.CHANGE, onChange);
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
			if(this._hasSkin == false){
				_back.graphics.clear();
				_back.graphics.beginFill(Style.BACKGROUND);
				_back.graphics.drawRect(0, 0, _width, _height);
				_back.graphics.endFill();
			}
			else if(_boxSkin){
				_back.addChild(_boxSkin);
			}
			
			if(_boxSkin.width!=_width||_boxSkin.height!=_height)
				changeSize();
			
			_tf.displayAsPassword = _password;
			
			if(_text != null)
			{
				_tf.text = _text;
			}
			else 
			{
				_tf.text = "";
			}
			if(_showMode == ONELINE){
				if(_tf.x == 0)
					_tf.x = 2;
				_tf.width = _width - _tf.x*2;
				if(_tf.text == "")
				{
					_tf.text = "X";
					_tf.height = Math.min(_tf.textHeight + 4, _height);
					_tf.text = "";
				}
				else
				{
					_tf.height = Math.min(_tf.textHeight + 4, _height);
				}
				_tf.wordWrap = false;
				_tf.y = Math.round(_height / 2 - _tf.height / 2);
			}
			else if(_showMode == WRAPLINE){
				_tf.wordWrap = true;
				if(_tf.x == 0)
					_tf.x = 2;
				if(_tf.y == 0)
					_tf.y = 2;
				_tf.width = _width - _tf.x*2;
				_tf.height = _height - _tf.y*2;
			}
		}
		
		private function changeSize():void{
			if(_sizeNoScale&&_boxSkin){//此处是不拉伸的情况下进行大小改变
				_boxSkin.bitmapData = _boxSkinData;
				changeSizeNoScale(_boxSkin);
			}
			else {
				_boxSkin.width =_width;
				_boxSkin.height =_height;
			}
		}
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal change handler.
		 * @param event The Event passed by the system.
		 */
		protected function onChange(event:Event):void
		{
			_text = _tf.text;
			event.stopImmediatePropagation();
			dispatchEvent(event);
			
			if(_tf.textHeight + _tf.y*2 > height&&changeByTextheight)
				height = _tf.textHeight + _tf.y*2 + 4;
			else if(_tf.textHeight + _tf.y*2 < height&&changeByTextheight&&height>_defaultHeight)
				height = _tf.textHeight + _tf.y*2 + 4;
				if(height<_defaultHeight)height = _defaultHeight;
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the text shown in this InputText.
		 */
		public function set text(t:String):void
		{
			_text = t;
			if(_text == null) _text = "";
			invalidate();
		}
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * Returns a reference to the internal text field in the component.
		 */
		public function get textField():TextField
		{
			return _tf;
		}
		
		/**
		 * Gets / sets the list of characters that are allowed in this TextInput.
		 */
		public function set restrict(str:String):void
		{
			_tf.restrict = str;
		}
		public function get restrict():String
		{
			return _tf.restrict;
		}
		
		/**
		 * Gets / sets the maximum number of characters that can be shown in this InputText.
		 */
		public function set maxChars(max:int):void
		{
			_tf.maxChars = max;
		}
		public function get maxChars():int
		{
			return _tf.maxChars;
		}
		
		/**
		 * Gets / sets whether or not this input text will show up as password (asterisks).
		 */
		public function set password(b:Boolean):void
		{
			_password = b;
			invalidate();
		}
		public function get password():Boolean
		{
			return _password;
		}

        /**
         * Sets/gets whether this component is enabled or not.
         */
        public override function set enabled(value:Boolean):void
        {
            super.enabled = value;
            _tf.tabEnabled = value;
        }

		public function get boxSkin():Bitmap
		{
			return _boxSkin;
		}

		public function set boxSkin(value:Bitmap):void
		{
			_hasSkin = true;
			var point:Point = new Point();
			if(value){
				_boxSkinData = value.bitmapData;
				_boxSkin = new Bitmap();
				_boxSkin.bitmapData = new BitmapData(value.width,value.height);
				_boxSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
			}
		}

		public function get sizeNoScale():Boolean
		{
			return _sizeNoScale;
		}

		public function set sizeNoScale(value:Boolean):void
		{
			_sizeNoScale = value;
		}

		public function get showMode():String
		{
			return _showMode;
		}

		public function set showMode(value:String):void
		{
			_showMode = value;
		}

		public function get changeByTextheight():Boolean
		{
			return _changeByTextheight;
		}

		public function set changeByTextheight(value:Boolean):void
		{
			_changeByTextheight = value;
		}
	}
}