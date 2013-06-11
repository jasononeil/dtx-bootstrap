package bootstrap;

using Detox;
using Floats;

@:useParentTemplate
class FloatInput extends NumberInput
{
	override function format(i:Float):String
	{
		return i.format("D");
	}
}