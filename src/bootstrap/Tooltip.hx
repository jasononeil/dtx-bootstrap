package bootstrap;

using Detox;
import js.html.Element;

@template('<div class="tooltip fade in">
	<div class="tooltip-arrow"><!-- --></div>
	<div class="tooltip-inner">$text</div>
</div>')
class Tooltip extends dtx.widget.Widget
{
	public var text:String;
	public var position(default,set):TooltipPosition;
	public var element(default,set):Element;
	
	public function new(?text=null, ?position=null, ?n:dtx.DOMNode, ?c:dtx.DOMCollection)
	{
		super();

		// Get the element we are attached to
		if (n != null && n.isElement()) 
			this.element = cast n 
		else if (c != null && c.length > 0) 
			this.element = cast c.getNode() 
		else 
			this.element = null;
		
		// Figure out the position to use
		if (position != null) 
		{
			this.position = position;
		}
		else
		{
			this.position = switch (element.attr('data-placement'))
			{
				case "left": Left;
				case "right": Right;
				case "bottom": Bottom;
				default: Top;
			}
		}

		// Figure out the text
		if (text != null)
		{
			this.text = text;
		}
		else 
		{
			this.text = element.attr("title");
		}
	}

	public function show()
	{
		if (element != null && text != null)
		{
			this.insertThisAfter(element);
			var ePos = element.pos();
			var tPos = this.pos();

			var top:Float, left:Float;
			switch (position) 
			{
				case Bottom:
					top = ePos.top + ePos.height; 
					left = ePos.left + ePos.width / 2 - tPos.width / 2;
				case Top:
					top = ePos.top - tPos.height; 
					left = ePos.left + ePos.width / 2 - tPos.width / 2;
				case Left:
					top = ePos.top + ePos.height / 2 - tPos.height / 2; 
					left = ePos.left - tPos.width;
				case Right:
					top = ePos.top + ePos.height / 2 - tPos.height / 2; 
					left = ePos.left + ePos.width;
			}

			this.setAttr("style", 'top: ${top}px; left: ${left}px; display: block').addClass('in');

			// Make sure the native tooltip doesn't clash
			element.setAttr("data-original-title", attr("title"))
			       .setAttr("title", "");
		}
		return this;
	}

	public function hide()
	{
		if (element != null && text != null)
		{
			this.removeClass("in");
			haxe.Timer.delay(function () {

				this.removeFromDOM();

				// Restore the native tooltip
				element.setAttr("title", attr("data-original-title"))
				       .removeAttr("data-original-title");
			}, 200);	
		}

		return this;
	}

	public function destroy()
	{
		this.removeFromDOM();
		if (element.attr("data-original-title") != "")
		{
			element.setAttr("title", attr("data-original-title"))
			       .removeAttr("data-original-title");
		}
		element.off("mouseenter.tooltip");
		element.off("mouseout.tooltip");
	}

	function set_element(e:Element)
	{
		e.on("mouseenter.tooltip", function (e) show());
		e.on("mouseout.tooltip", function (e) hide());
		return this.element = e;
	}

	function set_position(d)
	{
		this.removeClass('top bottom left right');
		this.addClass(Std.string(d).toLowerCase());
		return this.position = d;
	}

	public static var allTooltips = new Map<dtx.DOMNode, Tooltip>();

	/** Set the tooltip.  Will overwrite an existing one.  Returns the Tooltip object. */
	public static function tooltip(n:dtx.DOMNode, ?text:String, ?pos:TooltipPosition)
	{
		removeTooltip(n);
		var t = new Tooltip(text, pos, n);
		allTooltips.set(n, t);
		return t;
	}

	/** Removes the tooltip, returns the node */
	public static function removeTooltip(n:dtx.DOMNode)
	{
		if (allTooltips.exists(n))
		{
			allTooltips.get(n).destroy();
			allTooltips.remove(n);
		}
		return n;
	}
}

class CollectionTooltip
{
	/** Set the tooltip on all nodes in the collection.  Will overwrite existing tooltips.  Returns the final Tooltip object. */
	public static function tooltip(c:dtx.DOMCollection, ?text:String, ?pos:TooltipPosition)
	{
		var t:Tooltip = null;
		for (node in c) 
			t = Tooltip.tooltip(node, text, pos);
		return t;
	}

	/** Removes the tooltips, returns the collection */
	public static function removeTooltip(c:dtx.DOMCollection)
	{
		for (node in c) 
			Tooltip.removeTooltip(node);
		return c;
	}
}

enum TooltipPosition
{
	Left;
	Right;
	Top;
	Bottom;
}