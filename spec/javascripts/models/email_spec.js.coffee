describe "Email", ->
  describe "Routing", ->
    beforeEach ->
      @subject = 'subject'
      @body = 'body'

      @user = new CPP.Models.Email {
        subject: @subject
        body: @body
        id: 1
      }

    describe "url", ->
      it "should return emails for new model", ->
        sinon.stub(@user, "isNew").returns(true)
        expect(@user.url()).toEqual '/emails'

      it "should return emails/{id} for existing model", ->
        expect(@user.url()).toEqual '/emails/1'

    describe "when instantiated", ->
      it "should exhibit subject attribute", ->
        expect(@user.get 'subject').toEqual @subject

      it "should exhibit body attribute", ->
        expect(@user.get 'body').toEqual @body



