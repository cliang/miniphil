/**
 * Window.as
 * Keith Peters
 * version 0.9.10
 * 
 * A draggable window. Can be used as a container for other components.
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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	[Event(name="select", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="resize", type="flash.events.Event")]
	public class Window extends Component
	{
		protected var _title:String;
		protected var _titleBar:Panel;
		protected var _titleLabel:Label;
		protected var _panel:Panel;
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
		protected var _draggable:Boolean = true;
		protected var _minimizeButton:Sprite;
		protected var _hasMinimizeButton:Boolean = false;
		protected var _minimized:Boolean = false;
		protected var _hasCloseButton:Boolean;
		protected var _closeButton:PushButton;
		protected var _grips:Shape;
		protected var _gripsVisible:Boolean;
		protected var _titlePanelSkin:Bitmap;
		protected var _contantPanelSkin:Bitmap;
		protected var _allCloseButtonSkin:Bitmap;
		protected var _defaultCloseButtonSkin:Bitmap;
		protected var _downCloseButtonSkin:Bitmap;
		protected var _overCloseButtonSkin:Bitmap;
		protected var _hasTitlePanelSkin:Boolean;
		protected var _hasContantPanelSkin:Boolean;
		protected var _hasCloseButtonSkin:Boolean;
		protected var _titleHeight:uint;
		protected var _minimizeSkin:Bitmap;
		protected var _hasMinimizeSkin:Boolean;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param title The string to display in the title bar.
		 */
		public function Window(title:String="Window")
		{
			_title = title;
			super();
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			_titleBar = new Panel();
			_titleLabel = new Label(_title);
			_grips = new Shape();
			_panel = new Panel();
			_minimizeButton = new Sprite();
			_closeButton = new PushButton("", onClose);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_titleBar.filters = [];
			_titleBar.buttonMode = true;
			_titleBar.useHandCursor = true;
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			if(_titleHeight == 0){
				if(this._hasTitlePanelSkin)
					_titleHeight = this._titlePanelSkin.height;
				else _titleHeight = 20;
			}
			if(this._width == 0){
				if(this._hasTitlePanelSkin)
					_width = this._titlePanelSkin.width;
				else _width = 100;
			}
			super.addChild(_titleBar);
			_titleBar.height = _titleHeight;//此处是个bug在前面写会变成100…… 额
			
			for(var i:int = 0; i < 4; i++)
			{
				_grips.graphics.lineStyle(1, 0xffffff, .55);
				_grips.graphics.moveTo(0, 3 + i * 4);
				_grips.graphics.lineTo(100, 3 + i * 4);
				_grips.graphics.lineStyle(1, 0, .125);
				_grips.graphics.moveTo(0, 4 + i * 4);
				_grips.graphics.lineTo(100, 4 + i * 4);
			}
			_titleBar.content.addChild(_grips);
			_grips.visible = _gripsVisible;
			
			//_panel作为容器contant
			_panel.move(0, _titleHeight);
			if(this._height == 0){
				if(this._hasContantPanelSkin)
					_height = this._contantPanelSkin.height + _titleHeight;
				else _height = 100;
			}
			_panel.visible = !_minimized;
			super.addChild(_panel);
			
			//绘制了一个箭头
			if(!_hasMinimizeSkin){
				_minimizeButton.graphics.beginFill(0, 0);
				_minimizeButton.graphics.drawRect(-10, -10, 20, 20);
				_minimizeButton.graphics.endFill();
				_minimizeButton.graphics.beginFill(0, .35);
				_minimizeButton.graphics.moveTo(-5, -3);
				_minimizeButton.graphics.lineTo(5, -3);
				_minimizeButton.graphics.lineTo(0, 4);
				_minimizeButton.graphics.lineTo(-5, -3);
				_minimizeButton.graphics.endFill();
			}
			else {
				_minimizeSkin.x = -_minimizeSkin.width/2;
				_minimizeSkin.y = -_minimizeSkin.height/2;
				_minimizeButton.addChild(_minimizeSkin);
			}
			_minimizeButton.x = _titleHeight/2;
			_minimizeButton.y = _titleHeight/2;
			_minimizeButton.useHandCursor = true;
			_minimizeButton.buttonMode = true;
			_minimizeButton.addEventListener(MouseEvent.CLICK, onMinimize);
			if(this.hasMinimizeButton)
			super.addChild(_minimizeButton);
			
			//添加标题
			_titleLabel.move(_minimizeSkin.width/2 + _minimizeButton.width/2 + 5, 1);
			_titleBar.content.addChild(_titleLabel);
			
			if(_closeButton.width == 0|| _closeButton.height == 0){
				if(!this._hasCloseButton)
					_closeButton.setSize(8, 8);
			}
			if(_closeButton.x == 0&&_closeButton.y == 0)
				_closeButton.move(_width- _closeButton.width - (_titleHeight - _closeButton.height)/2,(_titleHeight - _closeButton.height)/2);
			else _closeButton.move(86,6);
			
			filters = [getShadow(4, false)];
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Overridden to add new child to content.
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			content.addChild(child);
			return child;
		}
		
		/**
		 * Access to super.addChild
		 */
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			_titleBar.color = _color;
			_panel.color = _color;
			_titleBar.width = width;
			_titleBar.draw();
			_titleLabel.x = _hasMinimizeButton ? (_minimizeSkin.width/2 + _minimizeButton.width/2+5) : 5;
			_closeButton.move(_width- _closeButton.width - (_titleHeight - _closeButton.height)/2,(_titleHeight - _closeButton.height)/2);
			_grips.x = _titleLabel.x + _titleLabel.width;
			_grips.y = (_titleHeight - _grips.height)/2 - 3;//3是一个偏移 由于_grips的绘图造成的
			if(_hasCloseButton)
			{
				_grips.width = _closeButton.x - _grips.x - 2;
			}
			else
			{
				_grips.width = _width - _grips.x - 2;
			}
			_grips.visible = _gripsVisible;
			_panel.setSize(_width, _height - _titleHeight);
			_panel.draw();
		}


		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseDown handler. Starts a drag.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			if(_draggable)
			{
				this.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
				parent.addChild(this); // move to top
			}
			dispatchEvent(new Event(Event.SELECT));
		}
		
		/**
		 * Internal mouseUp handler. Stops the drag.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function onMinimize(event:MouseEvent):void
		{
			minimized = !minimized;
		}
		
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function allCloseButtonSkin(value:Bitmap,num:uint = 4):void
		{
			_hasCloseButtonSkin = true;
			var point:Point = new Point();
			_allCloseButtonSkin = new Bitmap();
			_allCloseButtonSkin.bitmapData = new BitmapData(value.width,value.height);
			_allCloseButtonSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
			_closeButton.allSkin(this._allCloseButtonSkin,num);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets whether or not this Window will have a drop shadow.
		 */
		public function set shadow(b:Boolean):void
		{
			_shadow = b;
			if(_shadow)
			{
				filters = [getShadow(4, false)];
			}
			else
			{
				filters = [];
			}
		}
		public function get shadow():Boolean
		{
			return _shadow;
		}
		
		/**
		 * Gets / sets the background color of this panel.
		 */
		public function set color(c:int):void
		{
			_color = c;
			invalidate();
		}
		public function get color():int
		{
			return _color;
		}
		
		/**
		 * Gets / sets the title shown in the title bar.
		 */
		public function set title(t:String):void
		{
			_title = t;
			_titleLabel.text = _title;
		}
		public function get title():String
		{
			return _title;
		}
		
		/**
		 * Container for content added to this panel. This is just a reference to the content of the internal Panel, which is masked, so best to add children to content, rather than directly to the window.
		 */
		public function get content():DisplayObjectContainer
		{
			return _panel.content;
		}
		
		/**
		 * Sets / gets whether or not the window will be draggable by the title bar.
		 */
		public function set draggable(b:Boolean):void
		{
			_draggable = b;
			_titleBar.buttonMode = _draggable;
			_titleBar.useHandCursor = _draggable;
		}
		public function get draggable():Boolean
		{
			return _draggable;
		}
		
		/**
		 * Gets / sets whether or not the window will show a minimize button that will toggle the window open and closed. A closed window will only show the title bar.
		 */
		public function set hasMinimizeButton(b:Boolean):void
		{
			_hasMinimizeButton = b;
			if(_hasMinimizeButton)
			{
				super.addChild(_minimizeButton);
			}
			else if(contains(_minimizeButton))
			{
				removeChild(_minimizeButton);
			}
			invalidate();
		}
		public function get hasMinimizeButton():Boolean
		{
			return _hasMinimizeButton;
		}
		
		/**
		 *   控制面版的显示（通过小箭头）
		 */
		public function set minimized(value:Boolean):void
		{
			_minimized = value;
//			_panel.visible = !_minimized;
			if(_minimized)
			{
				if(contains(_panel)) removeChild(_panel);
				_minimizeButton.rotation = -90;
			}
			else
			{
				if(!contains(_panel)) super.addChild(_panel);
				_minimizeButton.rotation = 0;
			}
			dispatchEvent(new Event(Event.RESIZE));
		}
		public function get minimized():Boolean
		{
			return _minimized;
		}
		
		/**
		 * Gets the height of the component. A minimized window's height will only be that of its title bar.
		 */
		override public function get height():Number
		{
			if(contains(_panel))
			{
				return super.height;
			}
			else
			{
				return 20;
			}
		}

		/**
		 * Sets / gets whether or not the window will display a close button.
		 * Close button merely dispatches a CLOSE event when clicked. It is up to the developer to handle this event.
		 */
		public function set hasCloseButton(value:Boolean):void
		{
			_hasCloseButton = value;
			if(_hasCloseButton)
			{
				_titleBar.content.addChild(_closeButton);
			}
			else if(_titleBar.content.contains(_closeButton))
			{
				_titleBar.content.removeChild(_closeButton);
			}
			invalidate();
		}
		public function get hasCloseButton():Boolean
		{
			return _hasCloseButton;
		}

		/**
		 * Returns a reference to the title bar for customization.
		 */
		public function get titleBar():Panel
		{
			return _titleBar;
		}
		public function set titleBar(value:Panel):void
		{
			_titleBar = value;
		}

		/**
		 * Returns a reference to the shape showing the grips on the title bar. Can be used to do custom drawing or turn them invisible.
		 */		
		public function set gripsVisible(value:Boolean):void
		{
			_gripsVisible = true;
		}

		public function set titlePanelSkin(value:Bitmap):void
		{
			_hasTitlePanelSkin = true;
			var point:Point = new Point();
			_titlePanelSkin = new Bitmap();
			_titlePanelSkin.bitmapData = new BitmapData(value.width,value.height);
			_titlePanelSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
			_titleBar.sizeNoScale = true;
			_titleBar.backgroundSkin = this._titlePanelSkin;
		}
		
		public function set contantPanelSkin(value:Bitmap):void
		{
			_hasContantPanelSkin = true;
			var point:Point = new Point();
			_contantPanelSkin = new Bitmap();
			_contantPanelSkin.bitmapData = new BitmapData(value.width,value.height);
			_contantPanelSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
			_panel.sizeNoScale = true;
			_panel.backgroundSkin = this._contantPanelSkin;
		}

		public function get hasTitlePanelSkin():Boolean
		{
			return _hasTitlePanelSkin;
		}
		
		public function get hasContantPanelSkin():Boolean
		{
			return _hasContantPanelSkin;
		}

		public function get titleHeight():uint
		{
			return _titleHeight;
		}

		public function set titleHeight(value:uint):void
		{
			_titleHeight = value;
		}

		public function set defaultCloseButtonSkin(value:Bitmap):void
		{
			_defaultCloseButtonSkin = value;
		}

		public function set downCloseButtonSkin(value:Bitmap):void
		{
			_downCloseButtonSkin = value;
		}

		public function set overCloseButtonSkin(value:Bitmap):void
		{
			_overCloseButtonSkin = value;
		}

		public function get hasCloseButtonSkin():Boolean
		{
			return _hasCloseButtonSkin;
		}

		public function get closeButton():PushButton
		{
			return _closeButton;
		}

		public function set closeButton(value:PushButton):void
		{
			_closeButton = value;
		}

		public function set minimizeSkin(value:Bitmap):void
		{
			_hasMinimizeSkin = true;
			var point:Point = new Point();
			_minimizeSkin = new Bitmap();
			_minimizeSkin.bitmapData = new BitmapData(value.width,value.height);
			_minimizeSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
		}


	}
}