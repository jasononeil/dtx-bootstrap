package bootstrap;

import haxe.ds.IntMap;
using Detox;

@template("<select></select>")
class Select<T> extends dtx.widget.Widget
{
	var options:IntMap<Option<T>>;

	/** Given a collection of choices, create a select table that lets you pick one. */
	public function new(values:Iterable<T>, ?labels:Iterable<String>, ?multiple=false, ?clickToSelect=false)
	{
		super();

		// Add the options
		options = new IntMap();
		var i = 0;
		var vIter = values.iterator();
		var lIter = (labels != null) ? labels.iterator() : null;
		while (vIter.hasNext())
		{
			var v = vIter.next();

			var label = (labels != null && lIter.hasNext()) ? lIter.next() : Std.string(v);
			
			var o = new Option(i, label, v);
			this.append(o);
			options.set(i, o);
		}

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
}

@template("<option value='$id'>$label</option>")
class Option<T> extends dtx.widget.Widget
{
	public var value:T;
	public var id:Int;

	public function new(id:Int, label:String, value:T)
	{
		super();
		this.id = id;
		this.label = label;
		this.value = value;
	}
}