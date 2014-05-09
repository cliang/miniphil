/**
 * CheckBox.as
 * Keith Peters
 * version 0.9.10
 * 
 * A basic CheckBox component.
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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CheckBox extends Component
	{
		protected var _back:Sprite;
		protected var _button:Sprite;
		protected var _label:Label;
		protected var _labelText:String = "";
		protected var _selected:Boolean = false;
		protected var _hasBackSkin:Boolean;
		protected var _backSkin:Bitmap;
		protected var _hasButtonSkin:Boolean;
		protected var _buttonSkin:Bitmap;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this CheckBox.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param label String containing the label for this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (click in this case).
		 */
		public function CheckBox(label:String = "", defaultHandler:Function = null)
		{
			_labelText = label;
			if(defaultHandler != null)
			{
				addEventListener(MouseEvent.CLICK, defaultHandler);
			}
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
			_back = new Sprite();
			_button = new Sprite();
			_label = new Label(_labelText);
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
		}
		
		/**
		 * Creates the children for this component
		 */
		override protected function addChildren():void
		{
			_back.filters = [getShadow(2, true)];
			if(this._hasBackSkin){
				_back.addChild(this._backSkin);
			}
			else {
				_back.graphics.clear();
				_back.graphics.beginFill(Style.BACKGROUND);
				_back.graphics.drawRect(0, 0, 10, 10);
				_back.graphics.endFill();
			}
			addChild(_back);
			
			_button.filters = [getShadow(1)];
			_button.visible = false;
			if(this._hasButtonSkin){
				_button.addChild(this._buttonSkin);
			}
			else {
				_button.graphics.clear();
				_button.graphics.beginFill(Style.BUTTON_FACE);
				_button.graphics.drawRect(2, 2, 6, 6);
			}
			addChild(_button);
			
			addChild(_label);
			
			addEventListener(MouseEvent.CLICK, onClick);
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
			
			_label.text = _labelText;
			_label.draw();
			if(!this._hasBackSkin){
				_label.x = 12;
				_label.y = (10 - _label.height) / 2;
			}
			else {
				_label.x = _backSkin.width + 5;
				_label.y = _backSkin.height/2 -  _label.height/2;
			}
			_width = _label.width + 12;
			_height = 10;
		}
		
		
		
		
		///////////////////////////////////
		// event handler
		///////////////////////////////////
		
		/**
		 * Internal click handler.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onClick(event:MouseEvent):void
		{
			_selected = !_selected;
			_button.visible = _selected;
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets the label text shown on this CheckBox.
		 */
		public function set label(str:String):void
		{
			_labelText = str;
			invalidate();
		}
		public function get label():String
		{
			return _labelText;
		}
		
		/**
		 * Sets / gets the selected state of this CheckBox.
		 */
		public function set selected(s:Boolean):void
		{
			_selected = s;
			_button.visible = _selected;
		}
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * Sets/gets whether this component will be enabled or not.
		 */
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			mouseChildren = false;
		}

		public function set backSkin(value:Bitmap):void
		{
			if(!value)return;
			_hasBackSkin = true;
			_backSkin = value;
		}

		public function set buttonSkin(value:Bitmap):void
		{
			if(!value)return;
			_hasButtonSkin = true;
			_buttonSkin = value;
		}


	}
}