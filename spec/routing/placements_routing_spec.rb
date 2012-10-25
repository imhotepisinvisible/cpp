require "spec_helper"

describe PlacementsController do
  describe "routing" do

    it "routes to #index" do
      get("/placements").should route_to("placements#index")
    end

    it "routes to #new" do
      get("/placements/new").should route_to("placements#new")
    end

    it "routes to #show" do
      get("/placements/1").should route_to("placements#show", :id => "1")
    end

    it "routes to #edit" do
      get("/placements/1/edit").should route_to("placements#edit", :id => "1")
    end

    it "routes to #create" do
      post("/placements").should route_to("placements#create")
    end

    it "routes to #update" do
      put("/placements/1").should route_to("placements#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/placements/1").should route_to("placements#destroy", :id => "1")
    end

  end
end
