/**
 * Component.as
 * Keith Peters
 * version 0.9.10
 * 
 * Base class for all components
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
 * 
 * 
 * 
 * Components with text make use of the font PF Ronda Seven by Yuusuke Kamiyamane
 * This is a free font obtained from http://www.dafont.com/pf-ronda-seven.font
 */
 
package com.bit101.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	[Event(name="resize", type="flash.events.Event")]
	[Event(name="draw", type="flash.events.Event")]
	public class Component extends Sprite
	{
		// NOTE: Flex 4 introduces DefineFont4, which is used by default and does not work in native text fields.
		// Use the embedAsCFF="false" param to switch back to DefineFont4. In earlier Flex 4 SDKs this was cff="false".
		// So if you are using the Flex 3.x sdk compiler, switch the embed statment below to expose the correct version.
		
		// Flex 4.7 (labs/beta) sdk:
		// SWF generated with fontswf utility bundled with the AIR SDK released on labs.adobe.com with Flash Builder 4.7 (including ASC 2.0) 
		[Embed(source="assets/pf_ronda_seven.swf", symbol="PF Ronda Seven")]

		// Flex 4.x sdk:
		// [Embed(source="/assets/pf_ronda_seven.ttf", embedAsCFF="false", fontName="PF Ronda Seven", mimeType="application/x-font")]
		// Flex 3.x sdk:
//		[Embed(source="/assets/pf_ronda_seven.ttf", fontName="PF Ronda Seven", mimeType="application/x-font")]
		protected var Ronda:Class;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _tag:int = -1;
		protected var _enabled:Boolean = true;
		
		public static const DRAW:String = "draw";

		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this component.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function Component(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			init();
			this.addEventListener(Event.ADDED_TO_STAGE,onadded);
		}
		
		public function onadded(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,onadded);
			this.addChildren();
			this.draw();
		}
		
		/**
		 * Initilizes the component.
		 */
		protected function init():void
		{
			
		}
		
		/**
		 * Overriden in subclasses to create child display objects.
		 */
		protected function addChildren():void
		{
			
		}
		
		protected function changeSizeNoScale(faceBm:Bitmap):void{
			var bmd1:BitmapData = new BitmapData(this._width, faceBm.bitmapData.height,true);//位图临时数据1
			var point:Point = new Point(0,0);
			var rectangle:Rectangle = new Rectangle();
			var i:int;//循环临时数据
			if(faceBm.bitmapData.width<this._width){
				point.setTo(0, 0);
				rectangle.setTo(0 , 0, faceBm.bitmapData.width/2, faceBm.bitmapData.height);
				bmd1.copyPixels(faceBm.bitmapData,rectangle,point);
				point.setTo(this._width - faceBm.bitmapData.width/2, 0);
				rectangle.setTo(faceBm.bitmapData.width/2 , 0, faceBm.bitmapData.width/2, faceBm.bitmapData.height);
				bmd1.copyPixels(faceBm.bitmapData,rectangle,point);
				for(i=faceBm.bitmapData.width/2;i<this._width - faceBm.bitmapData.width/2;i++){
					point.setTo(i, 0);
					rectangle.setTo(faceBm.bitmapData.width/2, 0, 1, faceBm.bitmapData.height);
					bmd1.copyPixels(faceBm.bitmapData,rectangle,point);
				}
			}
			else {
				point.setTo(0, 0);
				rectangle.setTo(0 , 0, this._width/2, faceBm.bitmapData.height);
				bmd1.copyPixels(faceBm.bitmapData,rectangle,point);
				point.setTo(this._width/2, 0);
				rectangle.setTo(faceBm.bitmapData.width - this._width/2, 0, this._width/2, faceBm.bitmapData.height);
				bmd1.copyPixels(faceBm.bitmapData,rectangle,point);
			}
			faceBm.bitmapData = bmd1;
			
			var bmd2:BitmapData = new BitmapData(this._width, this._height,true);//位图临时数据2
			if(faceBm.bitmapData.height<this._height){
				point.setTo(0, 0);
				rectangle.setTo(0 , 0, faceBm.bitmapData.width, faceBm.bitmapData.height/2);
				bmd2.copyPixels(faceBm.bitmapData,rectangle,point);
				point.setTo(0 , this._height - faceBm.bitmapData.height/2);
				rectangle.setTo(0,faceBm.bitmapData.height/2 ,  faceBm.bitmapData.width, faceBm.bitmapData.height/2);
				bmd2.copyPixels(faceBm.bitmapData,rectangle,point);
				for(i=faceBm.bitmapData.height/2;i<this._height - faceBm.bitmapData.height/2;i++){
					point.setTo(0, i);
					rectangle.setTo(0, faceBm.bitmapData.height/2, faceBm.bitmapData.width , 1);
					bmd2.copyPixels(faceBm.bitmapData,rectangle,point);
				}
			}
			else {
				point.setTo(0, 0);
				rectangle.setTo(0 , 0, faceBm.bitmapData.width, this._height/2);
				bmd2.copyPixels(faceBm.bitmapData,rectangle,point);
				point.setTo(0,this._height/2);
				rectangle.setTo( 0,faceBm.bitmapData.height - this._height/2, faceBm.bitmapData.width, this._height/2);
				bmd2.copyPixels(faceBm.bitmapData,rectangle,point);
			}
			faceBm.bitmapData = bmd2;
		}
		
		/**
		 * DropShadowFilter factory method, used in many of the components.
		 * @param dist The distance of the shadow.
		 * @param knockout Whether or not to create a knocked out shadow.
		 */
		protected function getShadow(dist:Number, knockout:Boolean = false):DropShadowFilter
		{
			return new DropShadowFilter(dist, 45, Style.DROPSHADOW, 1, dist, dist, .3, 1, knockout);
		}
		
		/**
		 * Marks the component to be redrawn on the next frame.
		 */
		protected function invalidate():void
		{
//			draw();
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}
		
		
		
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Utility method to set up usual stage align and scaling.
		 */
		public static function initStage(stage:Stage):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		 * Moves the component to the specified position.
		 * @param xpos the x position to move the component
		 * @param ypos the y position to move the component
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
		
		/**
		 * Sets the size of the component.
		 * @param w The width of the component.
		 * @param h The height of the component.
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width = w;
			_height = h;
			dispatchEvent(new Event(Event.RESIZE));
			invalidate();
		}
		
		/**
		 * Abstract draw function.
		 */
		public function draw():void
		{
			if(hasEventListener(Event.ENTER_FRAME))
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			dispatchEvent(new Event(Component.DRAW));
		}
		
		
		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called one frame after invalidate is called.
		 */
		protected function onInvalidate(event:Event):void
		{
			if(!hasEventListener(Event.ENTER_FRAME)) return;
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}
		
		
		
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Sets/gets the width of the component.
		 */
		override public function set width(w:Number):void
		{
			_width = w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * Sets/gets the height of the component.
		 */
		override public function set height(h:Number):void
		{
			_height = h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}
		override public function get height():Number
		{
			return _height;
		}
		
		/**
		 * Sets/gets in integer that can identify the component.
		 */
		public function set tag(value:int):void
		{
			_tag = value;
		}
		public function get tag():int
		{
			return _tag;
		}
		
		/**
		 * Overrides the setter for x to always place the component on a whole pixel.
		 */
		override public function set x(value:Number):void
		{
			super.x = Math.round(value);
		}
		
		/**
		 * Overrides the setter for y to always place the component on a whole pixel.
		 */
		override public function set y(value:Number):void
		{
			super.y = Math.round(value);
		}

		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			mouseEnabled = mouseChildren = _enabled;
            tabEnabled = value;
			alpha = _enabled ? 1.0 : 0.5;
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}

	}
}