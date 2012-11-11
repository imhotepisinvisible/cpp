describe "LoginUser", ->
  describe "Routing", ->
    beforeEach ->
      @email = 'email@email.com'
      @password = 'password'

      @user = new CPP.Models.LoginUser {
        email: @email
        password: @password
      }

    describe "url", ->
      it "should return sessions", ->
        expect(@user.url()).toEqual 'sessions'

    describe "when instantiated", ->
      it "should exhibit email attribute", ->
        expect(@user.get 'email').toEqual @email

      it "should exhibit password attribute", ->
        expect(@user.get 'password').toEqual @password



