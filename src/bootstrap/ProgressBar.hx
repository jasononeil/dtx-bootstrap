package bootstrap;

@:template('
<div class="progress">
  <div class="progress-bar" role="progressbar" aria-valuenow="$value" aria-valuemin="$min" aria-valuemax="$max" style="width: $percentage%;" title="$percentage% Complete">
    <span class="sr-only">$percentage% Complete</span>
  </div>
</div>')
class ProgressBar extends dtx.widget.Widget {
	
	public var min:Int = 0;
	public var max(default,set):Int = 100;
	public var value(default,set):Float = 0;
	public var percentage:Float = 0;

	function set_value(v:Float) {
		this.percentage = v / max * 100;
		return this.value = v;
	}

	function set_max(m:Int) {
		this.percentage = value / m * 100;
		return this.max = m;
	}
}
