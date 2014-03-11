package bootstrap;

using Detox;

@:template(
"<div class='form-group'>
	<label dtx-name='labelNode' dtx-class-sr-only='inlineField' for='$id'>$label</label>
	<input dtx-name='inputNode' type='$type' value='$defaultValue' class='form-control' id='$id' name='$id' placeholder='$placeholder' />
	<div dtx-name='inputGroup' dtx-show='useInputGroups' class='input-group'></div>
	<div dtx-name='gridContainer' dtx-show='grid!=null'></div>
	<span dtx-name='helpNode' dtx-show='help!=null' class='help-block'>$help</span>
</div>")
class FormFieldInput extends dtx.widget.Widget
{
	public var id:String;
	public var label:String;
	public var placeholder:String;
	public var defaultValue:String;
	public var type:String;
	public var help:String;
	public var size(default,set):InputSize;

	public var disabled(default,set):Bool;
	public var grid(default,set):Null<Int> = null;
	public var inlineField = false;
	public var autocomplete(default, set):Bool;
	public var inputBefore(default, set):String;
	public var inputAfter(default, set):String;
	var useInputGroups:Bool = false;

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
		var input = (useInputGroups) ? this.inputGroup : this.inputNode;
		// Remove all other btn-$size classes
		input.removeClass("input-sm input-lg");

		// Add the class in the form btn-$size, unless the size is "Default"
		switch (s)
		{
			case Default: // no class to add
			case Large: input.addClass("input-lg");
			case Small: input.addClass("input-sm");
		}

		return size = s;
	}

	function set_disabled(d:Bool)
	{
		var input = (useInputGroups) ? this.inputGroup : this.inputNode;
		if (d) input.setAttr("disabled","disabled") else input.removeAttr("disabled");
		return disabled = d;
	}

	function set_autocomplete(a:Bool)
	{
		if (a) inputNode.setAttr( 'autocomplete', 'on' );
		else inputNode.setAttr( 'autocomplete', 'off' );
		return autocomplete = a;
	}

	function set_grid(g:Null<Int>)
	{
		var input = (useInputGroups) ? this.inputGroup : this.inputNode;
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


	public function addInputGroup( content:String, beforeOrAfter:BeforeOrAfter ) {
		this.inputGroup.append( this.inputNode );
		var addOn = '<span class="input-group-addon">$content</span>'.parse();
		switch beforeOrAfter {
			case Before: this.inputNode.beforeThisInsert(addOn);
			case After: this.inputNode.afterThisInsert(addOn);
		}
		useInputGroups = true;
	}

	function set_inputBefore( content:String ) {
		addInputGroup( content, Before );
		return inputBefore = content;
	}

	function set_inputAfter( content:String ) {
		addInputGroup( content, After );
		return inputAfter = content;
	}
}

enum ValidationState {
	Success;
	Warning( ?msg:String );
	Error( ?msg:String );
}

enum InputSize {
	Large;
	Default;
	Small;
}

enum BeforeOrAfter {
	Before;
	After;
}