#
#  Mixins for collections
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.app = window.app || {} # Allow scripts to be included in any order
app.Mixins = app.Mixins || {}


app.Mixins.OrderedCollection = {

  # This generates the next order number for new items
  nextOrder: ->
    return 1 unless @length
    @last().get("order") + 1


  # Elements are sorted by their original insertion order
  comparator: (element) ->
    element.get "order"


  # Parse is called whenever a model's data is returned by the server (in fetch)
  parse: (response) ->

    # Keep elements in the same order in which they are retrieved from the server
    _.each response, (element, index) ->
      element['order'] = index

    return response

}
