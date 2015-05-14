// stackoverflow.com/questions/17444408/how-to-add-a-custom-delete-option-for-backgrid-rows
var DeleteCell = Backgrid.Cell.extend({
    template: _.template("<div class=\"btn btn-small button-event-delete btn-danger\"><i class=\"icon-trash\" /></div>"),
    events: {
      "click": "deleteRow"
    },
    deleteRow: function (e) {
      //e.preventDefault();
      //this.model.collection.remove(this.model);
      e.stopPropagation();
      return this.model.destroy({
        wait: true,
        success: function(model, response) {
          return notify("success", "Event deleted");
        },
        error: function(model, response) {
          return notify("error", "Event could not be deleted");
        }
      });
    },
    render: function () {
      this.$el.html(this.template());
      this.delegateEvents();
      return this;
    }
});
