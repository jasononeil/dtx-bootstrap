package bootstrap;

import bootstrap.FormInput.InputSize;
using Detox;

@:template(
"<div class='$inputType'>
	<label dtx-name='labelNode'>
		<input type='$inputType' dtx-name='checkboxNode' id='$inputID' name='$name' value='$value' dtx-checked='checked' /> $label
	</label>
	<div dtx-name='gridContainer' dtx-show='grid!=null'></div>
	<span dtx-name='helpNode' dtx-show='help!=null' class='help-block'>$help</span>
</div>")
class FormFieldCheckbox extends dtx.widget.Widget
{
	public var id(default,set):String;
	public var name:String;
	public var label:String;
	public var type(default,set):String;
	public var value:String;
	public var help:String;
	public var checked:Bool;
	public var size(default,set):InputSize;

	private var inputType:String;
	private var inputID:String;

	public var inlineLabel(default,set):Bool;
	public var disabled(default,set):Bool;
	public var grid(default,set):Null<Int>;

	public function new(?label = "Click Me", ?id = "", ?value="", ?name = null, ?type = "checkbox", ?checked=false)
	{
		super();
		this.label = label;
		set_id(id);
		set_type(type);
		this.value = value;
		this.name = (name!=null) ? name : id;
		this.help = null;
		this.disabled = false;
		this.inlineLabel = false;
		this.grid = null;
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

	function set_disabled(d:Bool)
	{
		if (d) this.checkboxNode.setAttr("disabled","disabled") else this.checkboxNode.removeAttr("disabled");
		return disabled = d;
	}

	function set_inlineLabel(i:Bool)
	{
		if (i) this.labelNode.addClass('$type-inline') 
		else this.labelNode.removeClass('checkbox-inline radio-inline');
		return inlineLabel = i;
	}

	function set_id(newID:String)
	{
		if ( this.name==this.id ) this.name = newID;
		this.inputID = newID;
		return this.id = newID;
	}

	function set_type(t:String)
	{
		if (inlineLabel) {
			// Need to change "radio-inline" to "checkbox-inline" etc
			inlineLabel = false;
			inlineLabel = true;
		}
		this.inputType = t;
		return this.type = t;
	}

	function set_grid(g:Null<Int>)
	{
		if (g==null && grid!=null) {
			this.append( labelNode );
			gridContainer.removeClass('col-sm-${12-grid} col-sm-offset-$grid');
		}
		else if (g!=null) {
			gridContainer.addClass('col-sm-${12-g} col-sm-offset-$g');
			gridContainer.append( labelNode );
		}
		return grid = g;
	}
}