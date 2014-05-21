package bootstrap;

using Detox;

@:skipTemplating
class TimeInput extends NumberInput
{
	public function new(?min:Int=0, ?max:Int=86400, ?step:Int=300, ?start:Int=null, ?placeholder="")
	{
		super(min, max, step, start, placeholder);
		this.setAttr("type","text");
	}

	override function format(v:Float):String {
		var timestamp = DateTools.seconds( v );
		return DateTools.format( Date.fromTime(timestamp), "%r" );
	}

	override function parse(v:String):Float {
		return Date.fromString( v ).getTime() / 1000;
	}
}
