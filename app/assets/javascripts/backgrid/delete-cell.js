// stackoverflow.com/questions/17444408/how-to-add-a-custom-delete-option-for-backgrid-rows
(function (root, factory) {

  // CommonJS
  if (typeof exports == "object") {
    module.exports = factory(require("underscore"),
                             require("backbone"),
                             require("backgrid"));
  }
  // Browser
  else {
    factory(root._, root.Backbone, root.Backgrid);
  }

}(this, function (_, Backbone, Backgrid) {

  "use strict";

  var DeleteCell = Backgrid.Cell.extend({

          className: "delete-cell",
          template: _.template("<i class=\"icon-remove\" />"),
          events: {
                  "click": "deleteRow"
          },
          deleteRow: function (e) {
              e.preventDefault();
              this.model.collection.remove(this.model);
	  },
          render: function () {
	      this.$el.html(this.template());
	      this.delegateEvents();
	      return this;
	  }

        });
}));
