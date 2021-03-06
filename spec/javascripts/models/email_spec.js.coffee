describe "Email", ->
  describe "Routing", ->
    beforeEach ->
      @attrs =
        subject: 'subject'
        body: 'body'
        id: 1

      @user = new CPP.Models.TaggedEmail @attrs

    describe "url", ->
      it "should return emails for new model", ->
        sinon.stub(@user, "isNew").returns(true)
        expect(@user.url()).toEqual '/tagged_emails'

      it "should return tagged_emails/{id} for existing model", ->
        expect(@user.url()).toEqual '/tagged_emails/1'

    describe "when instantiated", ->
      it "should exhibit subject attribute", ->
        expect(@user.get 'subject').toEqual @attrs.subject

      it "should exhibit body attribute", ->
        expect(@user.get 'body').toEqual @attrs.body



