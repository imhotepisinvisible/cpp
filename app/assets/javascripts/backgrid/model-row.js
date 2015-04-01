// https://github.com/wyuenho/backgrid/issues/62
var ModelRow = Backgrid.Row.extend({
  render: function() {
    ModelRow.__super__.render.apply(this, arguments);
    this.$el.data('model', this.model);
    return this;
  }
});