describe "Email Routing", ->
  beforeEach ->
      @router = new CPP.Routers.TaggedEmails

    describe "Calls correct routing method", ->
      beforeEach ->
        @routeSpy = sinon.spy()
        try
          Backbone.history.start
            silent: true
            pushState: true

        @router.navigate "elsewhere"

      it "should call index route with an /tagged_emails route", ->
        @router.bind "route:index", @routeSpy
        @router.navigate "tagged_emails", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()

      it "should call view route with an /tagged_emails/{id} route", ->
        @router.bind "route:view", @routeSpy
        @router.navigate "tagged_emails/1", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()

      it "should call edit route with an /tagged_emails/{id}/edit route", ->
        @router.bind "route:edit", @routeSpy
        @router.navigate "tagged_emails/1/edit", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()


      it "should call indexCompany route with a /companies/{comp_id}/tagged_emails route", ->
        @router.bind "route:indexCompany", @routeSpy
        @router.navigate "companies/1/tagged_emails", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()

      it "should call new route with a /companies/{comp_id}/tagged_emails/new route", ->
        @router.bind "route:new", @routeSpy
        @router.navigate "companies/1/tagged_emails/new", true
        expect(@routeSpy).toHaveBeenCalledOnce()
        expect(@routeSpy).toHaveBeenCalledWith()

  describe "Handler functionality", ->
    beforeEach ->
      @collection = new Backbone.Collection()
      @collection.url = "/tagged_emails"
      @collectionFetchStub = sinon.stub(@collection, "fetch").yieldsTo "success"
      @emailsCollectionStub = sinon.stub(window.CPP.Collections, "TaggedEmails")
                                  .returns(@collection)

      @editViewStub = sinon.stub(window.CPP.Views.TaggedEmails, "Edit")
                               .returns(new Backbone.View())

      @indexViewStub = sinon.stub(window.CPP.Views.TaggedEmails, "Index")
                               .returns(new Backbone.View())

      @emailModel = new Backbone.Model()
      @emailModel.url = "/tagged_emails"
      @emailModelStub = sinon.stub(window.CPP.Models, "TaggedEmail")
                            .returns(@emailModel)
      sinon.stub(@emailModel, "fetch").yieldsTo "success"

      @companyModel = new Backbone.Model()
      @companyModel.url = '/companies'
      @companyModelStub = sinon.stub(window.CPP.Models, "Company")
                            .returns(@companyModel)
      sinon.stub(@companyModel, "fetch").yieldsTo "success"

    afterEach ->
        window.CPP.Collections.TaggedEmails.restore()
        window.CPP.Models.TaggedEmail.restore()
        window.CPP.Models.Company.restore()
        window.CPP.Views.TaggedEmails.Edit.restore()
        window.CPP.Views.TaggedEmails.Index.restore()

    describe "Index handler", ->
      it "should create an Emails collection", ->
        @router.index()
        expect(@emailsCollectionStub).toHaveBeenCalledOnce()
        expect(@emailsCollectionStub).toHaveBeenCalledWith()

      it "should create an EmailsIndex view on fetch success", ->
        @router.index()
        expect(@indexViewStub).toHaveBeenCalledOnce()
        expect(@indexViewStub).toHaveBeenCalledWith collection: @collection


      it "should not create an EventIndex view on fetch error", ->
        @collection.fetch.restore()
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.index()
        expect(@indexViewStub.callCount).toBe 0

      it "should fetch the event data from the server", ->
        @router.index()
        expect(@collectionFetchStub).toHaveBeenCalledOnce()
        expect(@collectionFetchStub).toHaveBeenCalledWith()

    describe "View handler", ->
      beforeEach ->
        @viewStub = sinon.stub(window.CPP.Views.TaggedEmails, "View")
                               .returns(new Backbone.View())

      afterEach ->
        window.CPP.Views.TaggedEmails.View.restore()

      it "should create an Email model", ->
        @router.view 1
        expect(@emailModelStub).toHaveBeenCalledOnce
        expect(@emailModelStub).toHaveBeenCalledWith id: 1

      it "should create a Company Model on fetch success", ->
        sinon.stub(@emailModel, 'get').withArgs('company_id').returns 2
        @router.view 1
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: 2

      it "should create an View on company fetch success", ->
        @router.view 1
        expect(@viewStub).toHaveBeenCalledOnce()
        expect(@viewStub).toHaveBeenCalledWith model: @emailModel

      it "should not create an EmailsView on company fetch error", ->
        @companyModel.fetch.restore()
        sinon.stub(@companyModel, "fetch").yieldsTo "error"
        @router.view 1
        expect(@viewStub.callCount).toBe 0

      it "should not create a Company Model on fetch error", ->
        @emailModel.fetch.restore()
        sinon.stub(@emailModel, "fetch").yieldsTo "error"
        @router.view 1
        expect(@companyModelStub.callCount).toBe 0

    describe "Edit handler", ->
      it "should create an Email model", ->
        @router.edit 1
        expect(@emailModelStub).toHaveBeenCalledOnce
        expect(@emailModelStub).toHaveBeenCalledWith id: 1

      it "should create an EmailsEdit view on fetch success", ->
        @router.edit 1
        expect(@editViewStub).toHaveBeenCalledOnce()
        expect(@editViewStub).toHaveBeenCalledWith model: @emailModel


      it "should not create an EmailsEdit view on fetch error", ->
        @emailModel.fetch.restore()
        sinon.stub(@emailModel, "fetch").yieldsTo "error"
        @router.edit 1
        expect(@editViewStub.callCount).toBe 0

    describe "New Handler", ->
      beforeEach ->
        @router.new 1

      it "should create an Email model", ->
        expect(@emailModelStub).toHaveBeenCalledWith
        expect(@emailModelStub).toHaveBeenCalledWith company_id: 1, subject: "Subject", body: "Email body"

      it "should create an Email collection", ->
        expect(@emailsCollectionStub).toHaveBeenCalledOnce()
        expect(@emailsCollectionStub).toHaveBeenCalledWith()

      it "should create an Edit view", ->
        expect(@editViewStub).toHaveBeenCalledOnce()
        expect(@editViewStub).toHaveBeenCalledWith model: @emailModel

    describe "IndexCompany Handler", ->
      it "should create an Email collection", ->
        @router.indexCompany 1
        expect(@emailsCollectionStub).toHaveBeenCalledOnce()
        expect(@emailsCollectionStub).toHaveBeenCalledWith()

      it "should create a Company Model on fetch success", ->
        @router.indexCompany 1
        expect(@companyModelStub).toHaveBeenCalledOnce()
        expect(@companyModelStub).toHaveBeenCalledWith id: 1

      it "should create an Index on company fetch success", ->
        @router.indexCompany 1
        expect(@indexViewStub).toHaveBeenCalledOnce()
        expect(@indexViewStub).toHaveBeenCalledWith collection: @collection

      it "should not create an Index View on company fetch error", ->
        @companyModel.fetch.restore()
        sinon.stub(@companyModel, "fetch").yieldsTo "error"
        @router.indexCompany 1
        expect(@indexViewStub.callCount).toBe 0

      it "should not create a Company Model on fetch error", ->
        @collection.fetch.restore()
        sinon.stub(@collection, "fetch").yieldsTo "error"
        @router.indexCompany 1
        expect(@companyModelStub.callCount).toBe 0
