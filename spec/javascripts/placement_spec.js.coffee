# describe "Placement", ->
#   describe "when used alone", ->
#     beforeEach ->
#       @position = "SDE Intern"
#       @location = "Barbican, London"
#       @description = "Work on Amazon Instant Video"
#       @deadline = new Date
#       @duration = "3 months"


#       @placement = new CPP.Models.Placement {
#         position: @position
#         location: @location
#         description: @description
#         deadline: @deadline
#         duration: @duration
#       }

#     describe "url", ->
#       describe "when no id is set", ->
#         it "should return the collection URL", ->
#           expect(@placement.url()).toEqual '/placements'

#     describe "when id is set", ->
#       it "should return the collection URL and id", ->
#         @placement.id = 1
#         expect(@placement.url()).toEqual '/placements/1'

#     describe "when instantiated", ->
#       it "should exhibit position attribute", ->
#         expect(@placement.get 'position').toEqual @position

#       it "should exhibit location attribute", ->
#         expect(@placement.get 'location').toEqual @location

#       it "should exhibit description attribute", ->
#         expect(@placement.get 'description').toEqual @description

#       it "should exhibit deadline attribute", ->
#         expect(@placement.get 'deadline').toEqual @deadline

#       it "should exhibit duration attribute", ->
#         expect(@placement.get 'duration').toEqual @duration

#   # describe "when used in form", ->

#   #   form = new Backbone.Form(model: new CPP.Models.Placement).render()
#   #   errors = form.validate()

#   #   describe "when saving required fields", ->
#   #     it "should not save when position is empty", ->
#   #       expect(errors.hasOwnProperty 'position').toBeTruthy()

#   #     it "should not save when description is empty", ->
#   #       expect(errors.hasOwnProperty 'description').toBeTruthy()

#   #     it "should not save when location is empty", ->
#   #       expect(errors.hasOwnProperty 'location').toBeTruthy()

#   #   describe "when saving optional fields", ->
#   #     it "should save when deadline is empty", ->
#   #       expect(errors.hasOwnProperty 'deadline').toBeFalsy()

#   #     it "should save when duration is empty", ->
#   #       expect(errors.hasOwnProperty 'duration').toBeFalsy()

