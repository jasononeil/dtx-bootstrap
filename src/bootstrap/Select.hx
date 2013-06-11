package bootstrap;

import haxe.ds.IntMap;
import js.html.SelectElement;
using Lambda;
using Detox;

@:template("<select></select>")
class Select<T> extends dtx.widget.Widget
{
	public var value(get,set):T;
	public var values(get,set):Iterable<T>;

	var select:SelectElement;
	var options:Map<Int, Option<T>>;
	var multiple:Bool;

	/** Given a collection of choices, create a select table that lets you pick one. */
	public function new(?values:Iterable<T>, ?labels:Iterable<String>, ?multiple=false, ?clickToSelect=false)
	{
		super();

		select = cast this.getNode();
		this.multiple = multiple;

		// Add the options
		setOptions( values, labels );

		// If multiple, add the attribute
		if (multiple) this.setAttr("multiple", "multiple");

		// If clickToSelect, add the events
		// Based on this, but it doesn't appear to be working ATM
		// http://stackoverflow.com/questions/2096259/html-select-multiple-input-field-how-to-select-deselect-toggle-a-value-with
		if (multiple && clickToSelect)
		{
			throw "not working at the moment";
			this.click("option", function (e) {
				var o = e.target.toDOMNode();

				if (o.attr("selected") != "") o.setAttr("selected", "")
				else o.setAttr("selected", "selected");

				return false;
			});
		}
	}

	public function setOptions( values:Iterable<T>, ?labels:Iterable<String> ) {
		if ( values != null ) {
			options = Option.buildOptionList( values, labels );
			this.empty();
			for (o in options ) this.append( o );
		} else options = new IntMap();
	}

	function get_value() {
		return options[ select.selectedIndex ].value;
	}

	function set_value( v ) {
		for ( o in options )
			o.selected = ( v == o.value );
		this.change();
		return v;
	}

	function get_values() {
		return [ for (o in options) if (o.selected) o.value ];
	}

	function set_values( v:Iterable<T> ) {
		for ( o in options ) 
			o.selected = v.has(o.value);
		return v;
	}
}

@:template("<option value='$id'>$label</option>")
class Option<T> extends dtx.widget.Widget {
	public var value:T;
	public var id:Int;
	public var label:String;

	public var option:js.html.OptionElement;
	public var selected(get,set):Bool;

	public function new(id:Int, label:String, value:T) {
		super();
		option = cast this.getNode();

		this.id = id;
		this.label = label;
		this.value = value;
	}

	inline function get_selected() return option.selected;
	inline function set_selected(v) return option.selected = v;

	static public function buildOptionList<T>( values:Iterable<T>, ?labels:Iterable<String> ):Map<Int, Option<T>> {
		var options = new IntMap();
		var i = 0;
		var vIter = values.iterator();
		var lIter = (labels != null) ? labels.iterator() : null;
		while (vIter.hasNext())
		{
			var v = vIter.next();
			var label = (labels != null && lIter.hasNext()) ? lIter.next() : Std.string(v);
			
			var o = new Option(i, label, v);
			options.set(i, o);
			i++;
		}
		return options;
	}
}