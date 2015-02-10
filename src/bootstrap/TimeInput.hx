package bootstrap;

using Detox;
using thx.core.Dates;
using thx.format.DateFormat;

@:skipTemplating
class TimeInput extends NumberInput
{
	public function new(?min:Int=0, ?max:Int=86400, ?step:Int=300, ?start:Int=null, ?placeholder="")
	{
		super(min, max, step, start, placeholder);
		this.setAttr("type","text");
	}

	override function format(v:Float):String {
		var timestamp = Date.now().getTime().snapPrev(Day)+(v*1000);
		var date = Date.fromTime(timestamp);
		return date.format("%I:%M%p", culture);
	}

	var parseRegex = ~/([012]?\d):([0-5]\d) ?(PM|AM)/;

	override function parse(v:String):Float {
		if ( parseRegex.match(v.toUpperCase()) ) {
			var hour = Std.parseInt( parseRegex.matched(1) );
			var min = Std.parseInt( parseRegex.matched(2) );
			switch [hour, parseRegex.matched(3)] {
				case [12,"AM"]: hour = 0;
				case [12,"PM"]: hour = 12;
				case [_,"PM"]: hour += 12;
				default:
			}
			return hour*3600 + min*60;
		}
		throw 'Failed to parse date: $v. Format must be HH:MM(PM/AM)';
	}
}
