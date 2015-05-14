// https://github.com/wyuenho/backgrid/issues/62
// https://github.com/wyuenho/backgrid/issues/221
var ModelRow = Backgrid.Row.extend({
  initialize: function(options) {
    ModelRow.__super__.initialize.apply(this, arguments);
    this.listenTo(this.model, "backgrid:selected", function (model, checked) {
      if (checked) this.$el.addClass("selected");
      else this.$el.removeClass("selected");
    });
  },
  render: function() {
    ModelRow.__super__.render.apply(this, arguments);
    this.$el.data('model', this.model);
    return this;
  }
});
