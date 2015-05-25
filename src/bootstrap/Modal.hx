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
      <div class="modal-header" dtx-name="header">
        <button type="button" class="close" dtx-name="closeBtn" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="bootstrap-modal-$modalID-title">$title</h4>
      </div>
      <div class="modal-body" dtx-name="body">
        $content
      </div>
      <div class="modal-footer" dtx-name="footer">
        <dtx:Button dtx-name="dismissBtn" label="Close" />
        <dtx:Button dtx-name="acceptBtn" label="Save Changes" type="$Success" />
      </div>
    </div>
  </div>
</div>')
class Modal extends dtx.widget.Widget
{
  static var modalCount = 0;

  public var title:String;
  public var content:String;

  public var width(default,set):Int;

  public function new(?title = "", ?content = "", ?width = null)
  {
    super();
    this.modalID = Std.string( modalCount++ );
    this.title = title;
    this.content = content;
    this.width = width;

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
    js.Browser.document.on("keyup.escapeModal", respondToKeyPress);
    backdrop.click(function (e)
    {
      // They clicked on this exact div
      if (e.target == backdrop.getNode())
      {
        dismiss();
      }
    });
  }

  function respondToKeyPress(e) {
    var keyEvent:js.html.KeyboardEvent = cast e;
    if (keyEvent.which == 27) dismiss();
    if (keyEvent.which == 13) accept();
  }

  function hide()
  {
    ModalBackdrop.removeBackdrop();
    this.removeClass("in").addClass("fade out");
    js.Browser.document.off("keyup.escapeModal", respondToKeyPress);
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
      return this.footer.append( b );
    else
      return this.footer.children().getNode( pos ).beforeThisInsert( b );
  }

  // Set up events that we can listen to...
  public function onClose(e:js.html.EventListener) this.on("ModalClose", e);
  public function onDismiss(e:js.html.EventListener) this.on("ModalDismiss", e);
  public function onAccept(e:js.html.EventListener) this.on("ModalAccept", e);
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
