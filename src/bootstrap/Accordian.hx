package bootstrap;

using Detox;

class Accordian extends dtx.widget.Widget
{
	public var accordianID:String;

	public function addItem( name:String, content:DOMCollection, ?collapsed=true ) {
		var item = sectionLoop.addItem({ name:name, collapsed:collapsed });
		item.widget.contentContainer.empty().append( content );
	}

	public function clearItems() {
		sectionLoop.empty();
	}
}

typedef AccordianSection = {
	name:String,
	collapsed:Bool
}