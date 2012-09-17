#
#  Simple global publish-subscribe mechanism
#
#  David Francisco - @dmfrancisco - http://dmfranc.com
#  Coimbra, Portugal
#

window.utils = window.utils || {} # Allow scripts to be included in any order

utils.pubsub = _.extend({}, Backbone.Events)
