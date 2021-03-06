describe "Student Signup", ->
  beforeEach ->
    @model = new Backbone.Model()
    @view = new CPP.Views.Students.Signup model: @model
    @form = new Backbone.Form schema: {}
    @backboneFormStub = sinon.stub(window.Backbone, "Form").returns(@form)

  afterEach ->
    window.Backbone.Form.restore()

  describe "Instantiation", ->
    it "should create a backbone form", ->
      expect(@backboneFormStub).toHaveBeenCalledOnce()
      expect(@backboneFormStub).toHaveBeenCalledWith model: @model

  describe "Rendering", ->
    it "returns the view object", ->
      expect(@view.render()).toEqual(@view)

