/**
 * Panel.as
 * Keith Peters
 * version 0.9.10
 * 
 * A rectangular panel. Can be used as a container for other components.
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
 * 面板  一张背景  一个空容器  一个遮罩层  没有然后了
 */
 
package com.bit101.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Panel extends Component
	{
		protected var _mask:Sprite;
		protected var _background:Sprite;
		protected var _color:int = -1;
		protected var _shadow:Boolean = true;
		protected var _gridSize:int = 10;
		protected var _showGrid:Boolean = false;
		protected var _gridColor:uint = 0xd0d0d0;
		protected var _backgroundSkin:Bitmap;
		protected var _backgroundSkinData:BitmapData;
		protected var _hasSkin:Boolean;
		protected var _sizeNoScale:Boolean;
		
		/**
		 * Container for content added to this panel. This is masked, so best to add children to content, rather than directly to the panel.
		 */
		public var content:Sprite;
		
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function Panel()
		{
			super();
		}
		
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			_background = new Sprite();
			_mask = new Sprite();
			content = new Sprite();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			if(this._hasSkin==false){
				setSize(100, 100);
			}
			else if(this._width==0||this._height==0){
				setSize(this._backgroundSkin.width,this._backgroundSkin.height);
			}
			super.addChild(_background);
			
			_mask.mouseEnabled = false;
			super.addChild(_mask);
			
			super.addChild(content);
			content.mask = _mask;
			
			filters = [getShadow(2, true)];
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
			if(this._hasSkin==false){
				_background.graphics.clear();
				_background.graphics.lineStyle(1, 0, 0.1);
				if(_color == -1)
				{
					_background.graphics.beginFill(Style.PANEL);
				}
				else
				{
					_background.graphics.beginFill(_color);
				}
				_background.graphics.drawRect(0, 0, _width, _height);
				_background.graphics.endFill();
			}
			else {
				if(!_background.contains(this._backgroundSkin))
				_background.addChild(this._backgroundSkin);
				if(_backgroundSkin.width!=_width||_backgroundSkin.height!=_height)
					changeSize();
			}
			
			if(!_hasSkin)
			drawGrid();
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff0000);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
		}
		
		private function changeSize():void{
			if(_sizeNoScale&&_backgroundSkin){//此处是不拉伸的情况下进行大小改变
				_backgroundSkin.bitmapData = _backgroundSkinData;
				changeSizeNoScale(_backgroundSkin);
			}
			else {
				_backgroundSkin.width =_width;
				_backgroundSkin.height =_height;
			}
		}
		
		protected function drawGrid():void
		{
			if(!_showGrid) return;
			
			_background.graphics.lineStyle(0, _gridColor);
			for(var i:int = 0; i < _width; i += _gridSize)
			{
				_background.graphics.moveTo(i, 0);
				_background.graphics.lineTo(i, _height);
			}
			for(i = 0; i < _height; i += _gridSize)
			{
				_background.graphics.moveTo(0, i);
				_background.graphics.lineTo(_width, i);
			}
		}
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets whether or not this Panel will have an inner shadow.
		 */
		public function set shadow(b:Boolean):void
		{
			_shadow = b;
			if(_shadow)
			{
				filters = [getShadow(2, true)];
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
		 * Gets / sets the backgrond color of this panel.
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
		 * Sets / gets the size of the grid.
		 */
		public function set gridSize(value:int):void
		{
			_gridSize = value;
			invalidate();
		}
		public function get gridSize():int
		{
			return _gridSize;
		}

		/**
		 * Sets / gets whether or not the grid will be shown.
		 */
		public function set showGrid(value:Boolean):void
		{
			_showGrid = value;
			invalidate();
		}
		public function get showGrid():Boolean
		{
			return _showGrid;
		}

		/**
		 * Sets / gets the color of the grid lines.
		 */
		public function set gridColor(value:uint):void
		{
			_gridColor = value;
			invalidate();
		}
		public function get gridColor():uint
		{
			return _gridColor;
		}

		public function set backgroundSkin(value:Bitmap):void
		{
			_hasSkin = Boolean(value);
			if(!_hasSkin) return;
			_backgroundSkinData = value.bitmapData;
			var point:Point = new Point();
			_backgroundSkin = new Bitmap();
			_backgroundSkin.bitmapData = new BitmapData(value.width,value.height);
			_backgroundSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
		}

		public function get sizeNoScale():Boolean
		{
			return _sizeNoScale;
		}

		public function set sizeNoScale(value:Boolean):void
		{
			_sizeNoScale = value;
		}


	}
}