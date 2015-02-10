package bootstrap;

import thx.culture.Culture;
using StringTools;
using Detox;

@:template("<input type='number' min='$min' max='$max' step='$step' placeholder='$placeholder'></input>")
class NumberInput extends dtx.widget.Widget
{
	public var culture:Culture = DtxBootstrapSetup.defaultCulture;

	public var min:Null<Float>;
	public var max:Null<Float>;
	public var step:Null<Float>;
	public var placeholder:String;

	public var value(default,set):Float;

	var input:DOMNode;

	public function new(min:Float, max:Float, ?step:Float=1, ?start:Float=null, ?placeholder="")
	{
		super();
		this.min = min;
		this.max = max;
		this.step = step;
		this.placeholder = placeholder;
		this.input = this.getNode(0);
		set_value(start);
		setupEvents();
	}

	function setupEvents()
	{
		// Only setup if there is no built in support
		// if (!Modernizr.inputtypes.number)
		// {
			input.keyup(function (e:js.html.KeyboardEvent) {
				switch (e.keyCode)
				{
					case 38: inc(); // up
					case 40: dec(); // down
					default: 
				}
			});
			input.wheel(function (e) {
				if (untyped e.deltaY > 0) dec();
				else inc();
				e.preventDefault();
			});
			input.blur(function (e) {
				var text = input.val().trim();
				value = parse(text);
			});
		// }
	}

	public function inc(?n:Float) changeBy((n != null) ? n : step);
	public function dec(?n:Float) changeBy((n != null) ? -n : -step);

	function set_value(v:Float)
	{
		if (v < min) v = min;
		if (v > max) v = max;
		input.setVal(format(v));
		return value = v;
	}

	function changeBy(i:Float)
	{
		if (value == null) value = min;
		set_value(value + i);
	}
	function format(i:Float) return ''+i;
	function parse(v:String) return Std.parseFloat(v);
}