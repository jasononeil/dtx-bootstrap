package bootstrap;

#if js
	import js.html.OptionElement;
	import js.html.SelectElement;
#end
import haxe.ds.IntMap;
using Lambda;
using Detox;

@:template("<select id='$id' name='$name'></select>")
class Select<T> extends dtx.widget.Widget
{
	public var value(get,set):T;
	public var values(get,set):Iterable<T>;
	public var id:String;
	public var name:String;
	public var disabled(default,set):Bool;
	public var multiple(default,set):Bool;

	var select: #if js SelectElement #else DOMNode #end;
	var options:Map<Int, Option<T>>;

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

		#if js
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
		#end
	}

	public function setOptions( values:Iterable<T>, ?labels:Iterable<String> ) {
		if ( values != null ) {
			options = Option.buildOptionList( values, labels, select );
		} else options = new IntMap();
	}

	function get_value() {
		var index = #if js select.selectedIndex #else this.find("option:selected").index() #end;
		var o = options[ index ];
		return (o != null) ? o.value : null;
	}

	function set_value( v:T ) {
		for ( o in options ) {
			o.selected = ( v == o.value );
		}
		#if js this.change(); #end
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

	function set_disabled(d:Bool) {
		if (d) this.setAttr("disabled","disabled") else this.removeAttr("disabled");
		return disabled = d;
	}

	function set_multiple(m:Bool) {
		if (m) this.setAttr("multiple","multiple") else this.removeAttr("multiple");
		return multiple = m;
	}
}

@:template("<option value='$valueStr'>$label</option>")
class Option<T> extends dtx.widget.Widget {
	public var value:T;
	public var valueStr:String;
	public var label:String;

	public var option:#if js OptionElement #else DOMNode #end;
	public var selected(get,set):Bool;

	public function new(valueStr:String, label:String, value:T) {
		super();
		option = cast this.getNode();

		this.valueStr = valueStr;
		this.label = label;
		this.value = value;
	}

	#if js 
		inline function get_selected() return option.selected;
		inline function set_selected(v) return option.selected = v;
	#else
		inline function get_selected() return option.attr("selected")!="";
		function set_selected(v:Bool) {
			if (v) option.setAttr("selected", "selected");
			else option.removeAttr("selected");
			return v;
		}
	#end

	static public function buildOptionList<T>( values:Iterable<T>, ?labels:Iterable<String>, selectNode:DOMNode, ?useIntValues=false ):Map<Int, Option<T>> {
		var options = new IntMap();
		selectNode.empty();
		var i = 0;
		var vIter = values.iterator();
		var lIter = (labels != null) ? labels.iterator() : null;
		while (vIter.hasNext())
		{
			var v = vIter.next();
			var label = (labels != null && lIter.hasNext()) ? lIter.next() : Std.string(v);
			
			var valueStr = useIntValues ? '$i' : '$v';
			var o = new Option(valueStr, label, v);
			selectNode.append( o );
			options.set(i, o);
			i++;
		}
		return options;
	}
}
