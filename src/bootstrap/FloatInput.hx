package bootstrap;

using Detox;
using Floats;

@:skipTemplating
class FloatInput extends NumberInput
{
	override function format(i:Float):String
	{
		return i.format("D");
	}
}