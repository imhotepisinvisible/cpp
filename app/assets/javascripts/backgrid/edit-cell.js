var EditCell = Backgrid.Cell.extend({
    template: _.template("<div class=\"btn btn-small button-event-edit\"><i class=\"icon-pencil\" /></div>"),
    events: {
      "click": "editRow"
    },
    editRow: function (e) {
      e.stopPropagation();
      return Backbone.history.navigate(Backbone.history.fragment + "/" + this.model.get('id') + "/edit", {
        trigger: true
      });
    },
    render: function () {
      this.$el.html(this.template());
      this.delegateEvents();
      return this;
    }
});
