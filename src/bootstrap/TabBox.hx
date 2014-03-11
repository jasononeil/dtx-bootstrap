package bootstrap;

using Detox;
import dtx.widget.Widget;

class TabBox extends Widget 
{
	public function addTab( id:String, name:String, tabContent:DOMCollection ) {

		var link = '<li><a href="#$id">$name</a></li>'.parse();
		var tab = '<div class="tab-pane fade" id="$id"></div>'.parse();
		tab.append(tabContent);

		var isFirst = nav.children().length==0;
		if ( isFirst ) {
			link.addClass('active');
			tab.addClass('active in');
		}

		link.appendTo(nav);
		tab.appendTo(content);

		link.click(function (e) {
			this.find('.active').removeClass('active in');
			link.addClass('active');
			tab.addClass('active in');
			e.preventDefault();
		});
	}
}