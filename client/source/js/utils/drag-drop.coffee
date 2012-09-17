#
#  Utils for drag and drop of one or more elements with jQueryUI
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#
#= require ../libs/md5
#

window.utils = window.utils || {} # Allow scripts to be included in any order


DragDrop =

  # This allows the row width to be mantained while dragging elements
  # FIXME This only works when a single task is dragged
  fixWidthHelper: (e, ui) ->
      ui.children().each ->
          $(this).width($(this).width())
      return ui


utils.dragDrop = DragDrop
