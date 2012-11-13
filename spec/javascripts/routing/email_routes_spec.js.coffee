describe "Email Routing", ->
  beforeEach ->
      @router = new CPP.Routers.Emails

    describe "Calls correct routing method", ->
      beforeEach ->
        @routeSpy = sinon.spy()
        try
          Backbone.history.start
            silent: true
            pushState: true

        @router.navigate "elsewhere"

      it "should call index route with an /emails route", ->
        @router.bind "route:index", @routeSpy
        @router.navigate "emails", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()

      it "should call view route with an /emails/{id} route", ->
        @router.bind "route:view", @routeSpy
        @router.navigate "emails/1", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()

      it "should call edit route with an /emails/{id}/edit route", ->
        @router.bind "route:edit", @routeSpy
        @router.navigate "emails/1/edit", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()


      it "should call indexCompany route with a /companies/{comp_id}/emails route", ->
        @router.bind "route:indexCompany", @routeSpy
        @router.navigate "companies/1/emails", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()

      it "should call new route with a /companies/{comp_id}/emails/new route", ->
        @router.bind "route:new", @routeSpy
        @router.navigate "companies/1/emails/new", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()

  describe "Handler functionality", ->
    beforeEach ->
      @collection = new Backbone.Collection()
      @collection.url = "/emails"

      @emailsCollectionStub = sinon.stub(window.CPP.Collections, "Emails")
                                  .returns(@collection)

      @emailsEditViewStub = sinon.stub(window.CPP.Views, "EmailsEdit")
                               .returns(new Backbone.View())

      @emailsIndexViewStub = sinon.stub(window.CPP.Views, "EmailsIndex")
                               .returns(new Backbone.View())

      @emailModel = new Backbone.Model()
      @emailModel.url = "/emails"
      @emailModelStub = sinon.stub(window.CPP.Models, "Email")
                            .returns(@emailModel)

      @companyModel = new Backbone.Model()
      @companyModel.url = '/companies'
      @companyModelStub = sinon.stub(window.CPP.Models, "Company")
                            .returns(@companyModel)

    afterEach ->
        window.CPP.Collections.Emails.restore()
        window.CPP.Models.Email.restore()
        window.CPP.Models.Company.restore()
        window.CPP.Views.EmailsEdit.restore()
        window.CPP.Views.EmailsIndex.restore()

    describe "Index handler", ->
      it "should create an Emails collection", ->
        @router.index()
        expect(@emailsCollectionStub).toHaveBeenCalledOnce()
        expect(@emailsCollectionStub).toHaveBeenCalledWith()

      it "should create an EmailsIndex view on fetch success", ->
        sinon.stub(@collection, "fetch").yieldsTo "success"
        @router.index()
        expect(@emailsIndexViewStub).toHaveBeenCalledOnce()
        expect(@emailsIndexViewStub).toHaveBeenCalledWith collection: @collection


      it "should not create an EventIndex view on fetch error", ->
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.index()
        expect(@emailsIndexViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        fetchStub = sinon.stub(@collection, "fetch").returns(null)
        @router.index()
        expect(fetchStub).toHaveBeenCalledOnce()
        expect(fetchStub).toHaveBeenCalledWith()

    describe "View handler", ->
      beforeEach ->
        @emailsViewStub = sinon.stub(window.CPP.Views, "EmailsView")
                               .returns(new Backbone.View())

      afterEach ->
        window.CPP.Views.EmailsView.restore()

      it "should create an Email model", ->
        @router.view 1
        expect(@emailModelStub).toHaveBeenCalledOnce
        expect(@emailModelStub).toHaveBeenCalledWith id: 1

      it "should create a Company Model on fetch success", ->
        sinon.stub(@emailModel, "fetch").yieldsTo "success"
        @emailModel.company_id = 2
        @router.view 1
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: 2

      it "should create an EmailsView on company fetch success", ->
        sinon.stub(@emailModel, "fetch").yieldsTo "success"
        sinon.stub(@companyModel, "fetch").yieldsTo "success"
        @router.view 1
        expect(@emailsViewStub).toHaveBeenCalledOnce()
        expect(@emailsViewStub).toHaveBeenCalledWith model: @emailModel

      it "should not create an EmailsView on company fetch error", ->
        sinon.stub(@emailModel, "fetch").yieldsTo "success"
        sinon.stub(@companyModel, "fetch").yieldsTo "error"
        @router.view 1
        expect(@emailsViewStub.callCount).toBe 0

      it "should not create a Company Model on fetch error", ->
        sinon.stub(@emailModel, "fetch").yieldsTo "error"
        @router.view 1
        expect(@companyModelStub.callCount).toBe 0

    describe "Edit handler", ->
      it "should create an Email model", ->
        @router.edit 1
        expect(@emailModelStub).toHaveBeenCalledOnce
        expect(@emailModelStub).toHaveBeenCalledWith id: 1

      it "should create an EmailsEdit view on fetch success", ->
        sinon.stub(@emailModel, "fetch").yieldsTo "success"
        @router.edit 1
        expect(@emailsEditViewStub).toHaveBeenCalledOnce()
        expect(@emailsEditViewStub).toHaveBeenCalledWith model: @emailModel


      it "should not create an EmailsEdit view on fetch error", ->
        sinon.stub(@emailModel, "fetch").yieldsTo "error"
        @router.edit 1
        expect(@emailsEditViewStub.callCount).toBe 0

    describe "New Handler", ->
      beforeEach ->
        @router.new 1

      it "should create an Email model", ->
        expect(@emailModelStub).toHaveBeenCalledWith
        expect(@emailModelStub).toHaveBeenCalledWith company_id: 1

      it "should create an Email collection", ->
        expect(@emailsCollectionStub).toHaveBeenCalledOnce()
        expect(@emailsCollectionStub).toHaveBeenCalledWith()

      it "should create an EmalsEdit view", ->
        expect(@emailsEditViewStub).toHaveBeenCalledOnce()
        expect(@emailsEditViewStub).toHaveBeenCalledWith model: @emailModel

    describe "IndexCompany Handler", ->
      it "should create an Email collection", ->
        @router.indexCompany 1
        expect(@emailsCollectionStub).toHaveBeenCalledOnce()
        expect(@emailsCollectionStub).toHaveBeenCalledWith()

      it "should create a Company Model on fetch success", ->
        sinon.stub(@collection, "fetch").yieldsTo "success"
        @router.indexCompany 1
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: 1

      it "should create an EmailsIndex on company fetch success", ->
        sinon.stub(@collection, "fetch").yieldsTo "success"
        sinon.stub(@companyModel, "fetch").yieldsTo "success"
        @router.indexCompany 1
        expect(@emailsIndexViewStub).toHaveBeenCalledOnce()
        expect(@emailsIndexViewStub).toHaveBeenCalledWith collection: @collection

      it "should not create an EmailsView on company fetch error", ->
        sinon.stub(@collection, "fetch").yieldsTo "success"
        sinon.stub(@companyModel, "fetch").yieldsTo "error"
        @router.indexCompany 1
        expect(@emailsIndexViewStub.callCount).toBe 0

      it "should not create a Company Model on fetch error", ->
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.indexCompany 1
        expect(@companyModelStub.callCount).toBe 0
