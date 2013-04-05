package bootstrap;

using Detox;

@template("<i class='$iconName'></i>")
class Icon extends dtx.widget.Widget
{
	public function new(iconName)
	{
		super();
		this.iconName = iconName;
	}
}