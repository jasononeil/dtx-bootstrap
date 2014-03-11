package bootstrap;

import bootstrap.FormFieldInput;
using Detox;

@:template(
"<div class='form-group'>
	<label dtx-name='labelNode' for='$id'>$label</label>
	<textarea dtx-name='inputNode' type='$type' rows='$rows' class='form-control' id='$id' name='$id' placeholder='$placeholder'>$defaultValue</textarea>
	<div dtx-name='gridContainer' dtx-show='grid!=null'></div>
	<span dtx-name='helpNode' dtx-show='help!=null' class='help-block'>$help</span>
</div>")
class FormFieldTextArea extends dtx.widget.Widget
{
	public var id:String;
	public var rows:Int = 3;
	public var label:String;
	public var placeholder:String;
	public var defaultValue:String;
	public var type:String;
	public var help:String;
	public var size(default,set):InputSize;

	public var disabled(default,set):Bool;
	public var grid(default,set):Null<Int> = null;

	public function new(?id = "", ?label = "Input", ?placeholder="", ?defaultValue="", ?type = "text")
	{
		super();
		this.id = id;
		this.label = label;
		this.placeholder = placeholder;
		this.defaultValue = defaultValue;
		this.type = type;
		this.help = null;
		this.disabled = false;
	}

	function set_size(s:InputSize)
	{
		var input = this.inputNode;
		// Remove all other btn-$size classes
		input.removeClass("input-sm input-lg");

		// Add the class in the form btn-$size, unless the size is "Default"
		switch (s)
		{
			case Default: // no class to add
			case Large: input.addClass("input-sm");
			case Small: input.addClass("input-lg");
		}

		return size = s;
	}

	function set_disabled(d:Bool)
	{
		var input = this.inputNode;
		if (d) input.setAttr("disabled","disabled") else input.removeAttr("disabled");
		return disabled = d;
	}

	function set_grid(g:Null<Int>)
	{
		var input = this.inputNode;
		if (g==null && grid!=null) {
			labelNode.afterThisInsert( input );
			labelNode.removeClass('col-sm-$grid');
			gridContainer.removeClass('col-sm-${12-grid}');
		}
		else if (g!=null) {
			labelNode.addClass('col-sm-$g');
			gridContainer.addClass('col-sm-${12-g}');
			gridContainer.append( input );
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