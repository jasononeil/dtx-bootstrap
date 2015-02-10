package bootstrap;

using Detox;
using thx.format.NumberFormat;

@:skipTemplating
class IntInput extends NumberInput
{
	public function new(min:Int, max:Int, ?step:Int=1, ?start:Int=null, ?placeholder="")
	{
		super(min, max, step, start, placeholder);
	}

	override function format(i:Float):String
	{
		return i.integer( culture );
	}

	override function parse(i:String):Float
	{
		return Std.parseInt(i);
	}
}