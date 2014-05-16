/**
 * Slider.as
 * Keith Peters
 * version 0.9.10
 * 
 * Abstract base slider class for HSlider and VSlider.
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
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name="change", type="flash.events.Event")]
	public class Slider extends Component
	{
		protected var _handle:Sprite;
		protected var _back:Sprite;
		protected var _backClick:Boolean = true;
		protected var _value:Number = 0;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _orientation:String;
		protected var _tick:Number = 0.01;
		protected var _backSkinData:BitmapData;
		protected var _handleSkinData:BitmapData;
		protected var _backSkin:Bitmap;
		protected var _handleSkin:Bitmap;
		protected var _spaceNum:int;
		
		public static const HORIZONTAL:String = "horizontal";
		public static const VERTICAL:String = "vertical";
		
		/**
		 * Constructor
		 * @param orientation Whether the slider will be horizontal or vertical.
		 * @param parent The parent DisplayObjectContainer on which to add this Slider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function Slider(orientation:String = Slider.HORIZONTAL,defaultHandler:Function = null)
		{
			_orientation = orientation;
			super();
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			super.init();
			_back = new Sprite();
			_handle = new Sprite();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			
			_handle.filters = [getShadow(1)];
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			_handle.buttonMode = true;
			_handle.useHandCursor = true;
			addChild(_handle);
			
			
			_max = Math.max(_backSkin.width,_backSkin.height);
			_max = _max - _spaceNum * 2;

			_back.addChild(_backSkin);
			if(_orientation == HORIZONTAL)
			{
				if(_backSkin.height > _backSkin.width){
					_backSkin.rotation = -90;
					_backSkin.y = _backSkin.height;
				}
			}
			else
			{
				if(_backSkin.width > _backSkin.height){
					_backSkin.rotation = 90;
					_backSkin.x = _backSkin.width;
				}
			}
			
			
			_handle.addChild(_handleSkin);
			if(_orientation == HORIZONTAL)
			{
				if(_handleSkin.height > _handleSkin.width){
					_handleSkin.rotation = -90;
					_handleSkin.y = _handleSkin.height;
				}
				_handleSkin.y = _handleSkin.y + _backSkin.height/2 -_handleSkin.height /2 ;
			}
			else
			{
				if(_handleSkin.width > _handleSkin.height){
					_handleSkin.rotation = 90;
						_handleSkin.x = _handleSkin.width;
				}
				_handleSkin.x = _handleSkin.x + _backSkin.width / 2 - _handleSkin.width / 2;
			}
			
			
			if(!_backSkin||!_handleSkin){
				if(_orientation == HORIZONTAL)
				{
					setSize(100, 10);
				}
				else
				{
					setSize(10, 100);
				}
			}
			else{
				trace(height,_backSkin.height,_handleSkin.height);
				this.height =Math.max(height, _backSkin.height,_handleSkin.height);
				this.width = Math.max(width,_backSkin.width,_handleSkin.width);
				trace(height,_backSkin.height,_handleSkin.height);
			}
		}
		
		/**
		 * Draws the back of the slider.
		 */
		protected function drawBack():void
		{
			if(!_backSkin){
				_back.graphics.clear();
				_back.graphics.beginFill(Style.BACKGROUND);
				_back.graphics.drawRect(0, 0, _width, _height);
				_back.graphics.endFill();
			}
			

			if(_backClick)
			{
				_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
			else
			{
				_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
			}
		}
		
		/**
		 * Draws the handle of the slider.
		 */
		protected function drawHandle():void
		{	
			if(!_handleSkin){
				_handle.graphics.clear();
				_handle.graphics.beginFill(Style.BUTTON_FACE);
				if(_orientation == HORIZONTAL)
				{
					_handle.graphics.drawRect(1, 1, _height - 2, _height - 2);
				}
				else
				{
					_handle.graphics.drawRect(1, 1, _width - 2, _width - 2);
				}
				_handle.graphics.endFill();
			}
			positionHandle();
		}
		
		/**
		 * _value取最大与最小的中间值
		 */
		protected function correctValue():void
		{
			if(_max > _min)
			{
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			}
			else
			{
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}
		
		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected function positionHandle():void
		{
			var range:Number;
			if(_orientation == HORIZONTAL)
			{
				if(!_handleSkin)
				range = _width - _height;
				else 
					range = _width - _handle.width;
				_handle.x = (_value - _min) / (_max - _min) * range;
			}
			else
			{
				if(!_backSkin)
				range = _height - _width;
				else 
					range = _height - _handle.height;
				_handle.y =(_value - _min) / (_max - _min) * range;
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
			drawBack();
			drawHandle();
		}
		
		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum = min;
			this.maximum = max;
			this.value = value;
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onBackClick(event:MouseEvent):void
		{
			if(_orientation == HORIZONTAL)
			{
				_handle.x = mouseX - _height / 2;
				_handle.x = Math.max(_handle.x, 0);
				_handle.x = Math.min(_handle.x, _width - _height);
				_value = _handle.x / (width - _height) * (_max - _min) + _min;
			}
			else
			{
				_handle.y = mouseY - _width / 2;
				_handle.y = Math.max(_handle.y, 0);
				_handle.y = Math.min(_handle.y, _height - _width);
				_value = (_height - _width - _handle.y) / (height - _width) * (_max - _min) + _min;
			}
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		/**
		 * Internal mouseDown handler. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if(!_handleSkin){
				if(_orientation == HORIZONTAL)
				{
					_handle.startDrag(false, new Rectangle(0, 0, _width - _height, 0));
				}
				else
				{
					_handle.startDrag(false, new Rectangle(0, 0, 0, _height - _width));
				}
			}
			else {
				if(_orientation == HORIZONTAL)
				{
					_handle.startDrag(false, new Rectangle(_spaceNum, 0, _max - _handleSkin.width, 0));
				}
				else
				{trace( _height, _handleSkin.height);
					_handle.startDrag(false, new Rectangle(0, _spaceNum, 0, _max - _handleSkin.height));
				}
			}
		}
		
		/**
		 * Internal mouseUp handler. Stops dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			stopDrag();
		}
		
		/**
		 * Internal mouseMove handler for when the handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onSlide(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			if(_orientation == HORIZONTAL)
			{
				_value = _handle.x / (width - _handleSkin.width) * (_max - _min) + _min;
			}
			else
			{
				_value = (_height - _handleSkin.height - _handle.y) / (height - _handleSkin.height) * (_max - _min) + _min;
			}
			if(_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets / gets whether or not a click on the background of the slider will move the handler to that position.
		 */
		public function set backClick(b:Boolean):void
		{
			_backClick = b;
			invalidate();
		}
		public function get backClick():Boolean
		{
			return _backClick;
		}
		
		/**
		 * Sets / gets the current value of this slider.
		 */
		public function set value(v:Number):void
		{
			_value = v;
			correctValue();
			positionHandle();
			
		}
		public function get value():Number
		{
			return Math.round(_value / _tick) * _tick;
		}

        /**
         * Gets the value of the slider without rounding it per the tick value.
         */
        public function get rawValue():Number
        {
            return _value;
        }
		
		/**
		 * Gets / sets the maximum value of this slider.
		 */
		public function set maximum(m:Number):void
		{
			_max = m;
			correctValue();
			positionHandle();
		}
		public function get maximum():Number
		{
			return _max;
		}
		
		/**
		 * Gets / sets the minimum value of this slider.
		 */
		public function set minimum(m:Number):void
		{
			_min = m;
			correctValue();
			positionHandle();
		}
		public function get minimum():Number
		{
			return _min;
		}
		
		/**
		 * Gets / sets the tick value of this slider. This round the value to the nearest multiple of this number. 
		 */
		public function set tick(t:Number):void
		{
			_tick = t;
		}
		public function get tick():Number
		{
			return _tick;
		}

		public function set backSkin(value:Bitmap):void
		{
			if(!value) return;
			_backSkin = value;
			_backSkinData = value.bitmapData;
			var point:Point = new Point();
			_backSkin = new Bitmap();
			_backSkin.bitmapData = new BitmapData(value.width,value.height);
			_backSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
		}

		public function set handleSkin(value:Bitmap):void
		{
			if(!value) return;
			_handleSkin = value;
			_handleSkinData = value.bitmapData;
			var point:Point = new Point();
			_handleSkin = new Bitmap();
			_handleSkin.bitmapData = new BitmapData(value.width,value.height);
			_handleSkin.bitmapData.copyPixels(value.bitmapData,new Rectangle(0 , 0, value.width, value.height),point);
		}

		public function get spaceNum():int
		{
			return _spaceNum;
		}

		public function set spaceNum(value:int):void
		{
			_spaceNum = value;
		}

		
	}
}
