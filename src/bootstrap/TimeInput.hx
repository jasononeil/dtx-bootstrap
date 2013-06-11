package bootstrap;

using Detox;
using ufront.util.TimeOfDayTools;
using Dates;

@:useParentTemplate
class TimeInput extends NumberInput
{
	public function new(?min:TimeOfDay=0, ?max:TimeOfDay=86400, ?step:TimeOfDay=300, ?start:TimeOfDay=null, ?placeholder="")
	{
		super(min, max, step, start, placeholder);
	}

	override function format(v:Float):String
	{
		return Std.int(v).timeToString();
	}
}