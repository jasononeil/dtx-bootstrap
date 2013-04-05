package bootstrap;

using Detox;
using Floats;

@useParentTemplate
class IntInput extends NumberInput
{
	public function new(min:Int, max:Int, ?step:Int=1, ?start:Int=null, ?placeholder="")
	{
		super(min, max, step, start, placeholder);
	}

	override function format(i:Float):String
	{
		return i.format("I");
	}
}