package bootstrap;

using Detox;
import js.html.Element;
import bootstrap.Button;

// @:template('<div role="dialog" tabindex="-1" class="modal hide" style="display: block;">
//   <div class="modal-header">
//     <button class="close" type="button">×</button>
//     <h3>$title</h3>
//   </div>
//   <div class="modal-body">
//     $content
//   </div>
//   <div class="modal-footer" dtx-name="footer">
//     <dtx:Button dtx-name="dismissBtn" label="\'Close\'" />
//     <dtx:Button dtx-name="acceptBtn" label="\'Save Changes\'" />
//   </div>
// </div>')

@:template('<div role="dialog" tabindex="-1" class="modal hide" aria-labelledby="bootstrap-modal-$modalID-title" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" aria-hidden="true">×</button>
        <h4 class="modal-title" id="bootstrap-modal-$modalID-title">$title</h4>
      </div>
      <div class="modal-body">
        $content
      </div>
      <div class="modal-footer" dtx-name="footer">
        <dtx:Button dtx-name="dismissBtn" label="\'Close\'" />
        <dtx:Button dtx-name="acceptBtn" label="\'Save Changes\'" />
      </div>
    </div>
  </div>
</div>')

class Modal extends dtx.widget.Widget
{
  static var modalCount = 0;

  public var title:String;
  public var content:String;

  public var header(get,null):DOMCollection;
  public var closeBtn(get,null):DOMCollection;
  public var body(get,null):DOMCollection;
  public var footer(get,null):DOMCollection;
  public var width(default,set):Int;

  public function new(?title = "", ?content = "", ?width = null)
  {
    super();
    this.modalID = Std.string( modalCount++ );
    this.title = title;
    this.content = content;
    this.width = width;

    acceptBtn.type = Success;
    acceptBtn.label = "Save Changes";
    dismissBtn.label = "Close";

    closeBtn.click(function (e) dismiss());
    dismissBtn.click(function (e) dismiss());
    acceptBtn.click(function (e) accept());
  }

  function set_width(w:Int)
  {
    if (w == null) this.setAttr("style", "display: block");
    else this.setAttr("style", 'display: block; width: ${w}px; margin-left: -${w/2}px');
    
    return width = w;
  }

  public function show()
  {
    var backdrop = ModalBackdrop.showBackdrop();
    this.removeClass("hide out").addClass("fade in");
    this.appendTo(js.Browser.document.body);

    // Events to escape
    js.Browser.document.on("keyup.escapeModal", function (e) {
      var keyEvent:js.html.KeyboardEvent = cast e;
      if (keyEvent.which == 27) dismiss();
      if (keyEvent.which == 13) accept();
    });
    backdrop.click(function (e)
    {
      // They clicked on this exact div
      if (e.target == backdrop.getNode())
      {
        dismiss();
      }
    });
  }

  function hide()
  {
    ModalBackdrop.removeBackdrop();
    this.removeClass("in").addClass("fade out");
    haxe.Timer.delay(function () {
      this.removeFromDOM();
    }, 200);
  }

  public function dismiss()
  {
    this.trigger("ModalDismiss");
    hide();
    this.trigger("ModalClose");
  }

  public function accept()
  {
    this.trigger("ModalAccept");
    hide();
    this.trigger("ModalClose");
  }

  public function addButton( b:Button, ?pos=-1 ) 
  {
    if ( pos==-1 )
      return this.footer.getNode().append( b );
    else 
      return this.footer.children().getNode( pos ).beforeThisInsert( b );
  }

  // Set up events that we can listen to...
  public function onClose(e:js.html.EventListener) this.on("ModalClose", e);
  public function onDismiss(e:js.html.EventListener) this.on("ModalDismiss", e);
  public function onAccept(e:js.html.EventListener) this.on("ModalAccept", e);

  // Events
  // It would be good to do some events here

  function get_header() return this.find(".modal-header");
  function get_body() return this.find(".modal-body");
  function get_footer() return this.find(".modal-footer");
  function get_closeBtn() return this.find(".close");
}

@:template('<div class="modal-backdrop fade"></div>')
class ModalBackdrop extends dtx.widget.Widget 
{
  function new()
  {
    super();
  }

  static var _backdrop:ModalBackdrop;

  static public function showBackdrop()
  {
    if (_backdrop == null) _backdrop = new ModalBackdrop();
    _backdrop.removeClass("out").addClass("in");
    _backdrop.appendTo(js.Browser.document.body);
    return _backdrop;
  }

  static public function removeBackdrop()
  {
    _backdrop.removeClass("in").addClass("out");
    if (_backdrop != null)
    {
      haxe.Timer.delay(function () {
        _backdrop.removeFromDOM();
      }, 200);
    }
  }
}