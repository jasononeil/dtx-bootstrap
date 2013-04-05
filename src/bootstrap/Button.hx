package bootstrap;

using Detox;

@template("<a href='javascript:void(0)' class='btn' title='$tooltip'>$label</a>")
class Button extends dtx.widget.Widget
{
	public var label:String;
	public var tooltip:String;
	public var icon(default,set):Icon;
	public var type(default,set):ButtonType;
	public var size(default,set):ButtonSize;
	public var disabled(default,set):Bool;

	public function new(?label = " ", ?tooltip = "", ?icon = null, ?type:ButtonType, ?size:ButtonSize, ?disabled=false)
	{
		super();
		this.label = label;
		this.tooltip = tooltip;
		this.icon = icon;
		this.size = (size != null) ? size : Default;
		this.type = (type != null) ? type : Default;
		this.disabled = disabled;
	}

	override function init()
	{
		// Check we're setting the icon
	}

	function set_icon(icon:Icon)
	{
		if (icon != null) 
			this.prepend(icon);
		else 
			this.icon.removeFromDOM();

		return this.icon = icon;
	}

	function set_type(t:ButtonType)
	{
		// Remove all other btn-$type classes
		this.removeClass("btn-primary btn-info btn-success btn-warning btn-danger btn-link");

		// Add the class in the form btn-$type, unless the type is "Default"
		switch (t)
		{
			case Default: // no class to add
			default: 
				this.addClass("btn-" + Std.string(t).toLowerCase());
		};

		return type = t;
	}

	function set_size(s:ButtonSize)
	{
		// Remove all other btn-$size classes
		this.removeClass("btn-large btn-small btn-mini");

		// Add the class in the form btn-$size, unless the size is "Default"
		switch (s)
		{
			case Default: // no class to add
			default: 
				this.addClass("btn-" + Std.string(s).toLowerCase());
		};

		return size = s;
	}

	function set_disabled(d:Bool)
	{
		if (d) this.addClass("disabled") else this.removeClass("disabled");
		return disabled = d;
	}
}

enum ButtonType
{
	Default;
	Primary;
	Info;
	Success;
	Warning;
	Danger;
	Link;
}

enum ButtonSize
{
	Large;
	Default;
	Small;
	Mini;
}