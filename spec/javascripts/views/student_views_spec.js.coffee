describe "Students Views", ->
  describe "Signup View", ->
    beforeEach ->
      @form = new Backbone.Form schema: {}
      @backboneFormStub = sinon.stub(window.Backbone, "Form").returns(@form)
      @model = new Backbone.Model()
      @view = new CPP.Views.StudentsSignup model: @model

    afterEach ->
      window.Backbone.Form.restore()

    describe "Instantiation", ->
      it "should create a backbone form", ->
        expect(@backboneFormStub).toHaveBeenCalledOnce()
        expect(@backboneFormStub).toHaveBeenCalledWith model: @model

    describe "Rendering", ->
      it "returns the view object", ->
        expect(@view.render()).toEqual(@view)

