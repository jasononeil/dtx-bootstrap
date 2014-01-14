package bootstrap;

import bootstrap.FormFieldInput;
using Detox;

@:template(
"<div class='form-group'>
	<label dtx-name='labelNode' dtx-class-sr-only='inlineField' for='$id'>$label</label>
	<dtx:Select dtx-name='selectWidget' id='id' disabled='disabled' />
	<div dtx-name='gridContainer' dtx-show='grid!=null'></div>
	<span dtx-name='helpNode' dtx-show='help!=null' class='help-block'>$help</span>
</div>")
class FormFieldSelect<T:String> extends dtx.widget.Widget
{
	public var id:String;
	public var label:String;
	public var help:String;
	public var size(default,set):InputSize;
	public var value(default,set):T;

	public var selectWidget:Select<T>;

	public var disabled:Bool;
	public var grid(default,set):Null<Int> = null;
	public var inlineField = false;

	public function new(?id = "", ?label = "Select")
	{
		super();
		this.id = id;
		this.label = label;
		this.help = null;
		this.disabled = false;
		this.selectWidget.addClass("form-control");
	}

	function set_value(v:T)
	{
		this.selectWidget.value = v;
		return this.value = v;
	}

	function set_size(s:InputSize)
	{
		// Remove all other btn-$size classes
		this.removeClass("input-sm input-lg");

		// Add the class in the form btn-$size, unless the size is "Default"
		switch (s)
		{
			case Default: // no class to add
			case Large: this.addClass("input-sm");
			case Small: this.addClass("input-sm");
		};

		return size = s;
	}

	function set_grid(g:Null<Int>)
	{
		if (g==null && grid!=null) {
			labelNode.afterThisInsert( selectWidget );
			labelNode.removeClass('col-sm-$grid');
			gridContainer.removeClass('col-sm-${12-grid}');
		}
		else if (g!=null) {
			labelNode.addClass('col-sm-$g');
			gridContainer.addClass('col-sm-${12-g}');
			gridContainer.append( selectWidget );
		}
		return grid = g;
	}

	public function setValidation( ?v:ValidationState, ?msg:String ) 
	{
		if ( v==null && msg!=null ) v = Error( msg );
		this.removeClass("has-success has-warning has-error");
		if ( v!=null ) switch (v)
		{
			case Success:
				this.addClass("has-success");
			case Warning(msg):
				this.addClass("has-warning");
				this.help = msg;
			case Error(msg):
				this.addClass("has-error");
				this.help = msg;
		}
	}
}