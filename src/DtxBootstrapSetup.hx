/** For Bootstrap UI elements which require setup with the document, the setup occurs in this class, rather than on an individual widget.

For example, we can put the event listeners that trigger all tooltips here.

To run all the setups, call setupAll();
*/

using Detox;
using bootstrap.Tooltip;

class DtxBootstrapSetup
{
	/** Call all the other setups. */
	public static function setupAll()
	{
		setupTooltips();
		setupPopovers();
		setupButtonRadios();
		setupButtonCheckboxes();
		setupButtonRadios();
		setupButtonToggle();
		setupButtonLoading();
		setupTabs();
		setupDropdowns();
		setupScrollspy();
		setupAlerts();
		setupCollapse();
		setupCarousel();
		setupTypeahead();
		setupAffix();
	}
	
	public static function setupTooltips()
	{
		var t:Tooltip;
		js.Browser.document.hover("[data-toggle=tooltip]", function (e) {
			var elm:js.html.Element = cast e.target;
			t = elm.tooltip().show();
		}, function (e) {
			t.hide();
		});
	}
	
	public static function setupPopovers()
	{
		
	}
	
	public static function setupButtonRadios()
	{
		
	}
	
	public static function setupButtonCheckboxes()
	{
		
	}
	
	public static function setupButtonToggle()
	{
		
	}
	
	public static function setupButtonLoading()
	{
		
	}
	
	public static function setupTabs()
	{
		
	}
	
	public static function setupDropdowns()
	{
		
	}
	
	public static function setupScrollspy()
	{
		
	}
	
	public static function setupAlerts()
	{
		
	}
	
	public static function setupCollapse()
	{
		
	}
	
	public static function setupCarousel()
	{
		
	}
	
	public static function setupTypeahead()
	{
		
	}
	
	public static function setupAffix()
	{
		
	}

}