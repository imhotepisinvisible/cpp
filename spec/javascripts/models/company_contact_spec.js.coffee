describe "Company Contact", ->
  beforeEach ->
    @attrs = 
      first_name: "Sarah"
      last_name: "Tattersall"
      role: "Devevloper"
      email: "st@email.com"
      id: 1

    @contact = new CPP.Models.CompanyContact @attrs

  describe "url", ->
    describe "when no id is set", ->
      it "should return the collection URL", ->
        sinon.stub(@contact, 'isNew').returns(true)
        expect(@contact.url()).toEqual '/company_contacts'

    describe "when id is set", ->
      it "should return the collection URL and id", ->
        expect(@contact.url()).toEqual '/company_contacts/1'

  describe "when instantiated", ->
    it "should be valid", ->
      expect(@contact.isValid()).toBeTruthy()

    it "should exhibit first name attribute", ->
      expect(@contact.get 'first_name').toEqual @attrs.first_name

    it "should exhibit last attribute", ->
      expect(@contact.get 'last_name').toEqual @attrs.last_name

    it "should exhibit email attribute", ->
      expect(@contact.get 'email').toEqual @attrs.email

    it "should exhibit role attribute", ->
      expect(@contact.get 'role').toEqual @attrs.role

  describe "when saving required fileds", ->
    beforeEach ->
      spy = @errorSpy = sinon.spy();
      init = CPP.Models.CompanyContact::initialize
      CPP.Models.CompanyContact::initialize = ->
        spy(@, "validated:invalid")
        init.call this

      @contact = new CPP.Models.CompanyContact @attrs

    afterEach ->
      expect(@errorSpy).toHaveBeenCalledOnce()

    it "should not save when first_name is empty", ->
      @contact.save 'first_name': ""


    it "should not save when last_name is empty", ->
      @contact.save 'last_name': ""


    it "should not save when role is empty", ->
      @contact.save 'role': ""


    it "should not save when email is empty", ->
      @contact.save 'email': ""

    it "should not save if email isn't the correct format", ->
      @contact.save 'email': 'invalid'

