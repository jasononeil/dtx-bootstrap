package bootstrap;

using Detox;
using thx.format.Format;

@:skipTemplating
class FloatInput extends NumberInput
{
	override function format(i:Float):String
	{
		return i.f("D");
	}
}