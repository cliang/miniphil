/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * Dispatched when the display object receives focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the display object loses focus.
	 *
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * A component that can receive focus.
	 *
	 * @see feathers.core.IFocusManager
	 */
	public interface IFocusDisplayObject extends IFeathersDisplayObject
	{
		/**
		 * The current focus manager for this component.
		 */
		function get focusManager():IFocusManager;

		/**
		 * @private
		 */
		function set focusManager(value:IFocusManager):void;

		/**
		 * Determines if this component can receive focus.
		 *
		 * <p>In the following example, the focus is disabled:</p>
		 *
		 * <listing version="3.0">
		 * object.isFocusEnabled = false;</listing>
		 */
		function get isFocusEnabled():Boolean;

		/**
		 * @private
		 */
		function set isFocusEnabled(value:Boolean):void;

		/**
		 * The next object that will receive focus when the tab key is pressed.
		 * If <code>null</code>, defaults to the next child on the display list.
		 *
		 * <p>In the following example, the next tab focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.nextTabFocus = otherObject;</listing>
		 */
		function get nextTabFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set nextTabFocus(value:IFocusDisplayObject):void;

		/**
		 * The previous object that will receive focus when the tab key is
		 * pressed while holding shift. If <code>null</code>, defaults to the
		 * previous child on the display list.
		 *
		 * <p>In the following example, the previous tab focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.previousTabFocus = otherObject;</listing>
		 */
		function get previousTabFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set previousTabFocus(value:IFocusDisplayObject):void;

		/**
		 * If the object has focus, an additional visual indicator may
		 * optionally be displayed to highlight the object. Calling this
		 * function may have no effect. It's merely a suggestion to the object.
		 *
		 * <p><strong>Important:</strong> This function will not give focus to
		 * the display object if it doesn't have focus. To give focus to the
		 * display object, you should set the <code>focus</code> property on
		 * the focus manager.</p>
		 *
		 * <listing version="3.0">
		 * object.focusManager.focus = object;</listing>
		 *
		 * @see #hideFocus()
		 * @see feathers.core.IFocusManager#focus
		 */
		function showFocus():void;

		/**
		 * If the visual indicator of focus has been displayed by
		 * <code>showFocus()</code>, call this function to hide it.
		 *
		 * <p><strong>Important:</strong> This function will not clear focus
		 * from the display object if it has focus. To clear focus from the
		 * display object, you should set the <code>focus</code> property on
		 * the focus manager to <code>null</code> or another display object.</p>
		 *
		 * @see #showFocus()
		 * @see feathers.core.IFocusManager#focus
		 */
		function hideFocus():void;
	}
}
