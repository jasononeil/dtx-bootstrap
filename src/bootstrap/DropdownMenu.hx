package bootstrap;

import js.html.EventListener;
using Detox;
using Lambda;

@:template('<ul class="dropdown-menu" role="menu"></ul>')
class DropdownMenu extends dtx.widget.Widget
{
	public function new()
	{
		super();
	}

	public function addItem(name:String, ?href:String, ?fn:EventListener)
	{
		this.append(new DropdownItem(name, href, fn));
	}

	public function addDivider()
	{
		this.append(new DropdownSeparator());
		
		// Set up escape events...
		Detox.document.click(function (e) {
			// If they click on any element not inside this dropdown widget, ie - they click outside
			var n:dtx.DOMNode = cast e.target;
			var trigger = this.getNode().parent();
			if (n.ancestors().has(trigger) == false)
			{
				trigger.removeClass("open");
			}
		});
	}
}

@:template('<li><a tabindex="-1" href="javascript:void(0)">$label</a></li>')
class DropdownItem extends dtx.widget.Widget 
{
	public function new(label:String, ?href:String, ?fn:EventListener)
	{
		super();
		this.label = label;
		if (fn != null) this.click(function (e) {
			closeMenu(e); 
			fn(e); 
		});
		if (href != null) this.firstChildren().setAttr("href", href).click(closeMenu);
	}

	inline function closeMenu(e) this.parent().parent().removeClass("open"); 
}

@:template('<li class="divider"></li>')
class DropdownSeparator extends dtx.widget.Widget {}