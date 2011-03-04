require "spec_helper"

describe InputsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/inputs" }.should route_to(:controller => "inputs", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/inputs/new" }.should route_to(:controller => "inputs", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/inputs/1" }.should route_to(:controller => "inputs", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/inputs/1/edit" }.should route_to(:controller => "inputs", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/inputs" }.should route_to(:controller => "inputs", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/inputs/1" }.should route_to(:controller => "inputs", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/inputs/1" }.should route_to(:controller => "inputs", :action => "destroy", :id => "1")
    end

  end
end
