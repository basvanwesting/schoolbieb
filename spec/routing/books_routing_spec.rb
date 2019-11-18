require "rails_helper"

RSpec.describe BooksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/books").to route_to("books#index")
    end

    context 'fiction' do
      it "routes to #new" do
        expect(:get => "/books/fictions/new").to route_to("books/fictions#new")
      end

      it "routes to #show" do
        expect(:get => "/books/fictions/1").to route_to("books/fictions#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/books/fictions/1/edit").to route_to("books/fictions#edit", :id => "1")
      end


      it "routes to #create" do
        expect(:post => "/books/fictions").to route_to("books/fictions#create")
      end

      it "routes to #update via PUT" do
        expect(:put => "/books/fictions/1").to route_to("books/fictions#update", :id => "1")
      end

      it "routes to #update via PATCH" do
        expect(:patch => "/books/fictions/1").to route_to("books/fictions#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/books/fictions/1").to route_to("books/fictions#destroy", :id => "1")
      end
    end

    context 'non_fiction' do
      it "routes to #new" do
        expect(:get => "/books/non_fictions/new").to route_to("books/non_fictions#new")
      end

      it "routes to #show" do
        expect(:get => "/books/non_fictions/1").to route_to("books/non_fictions#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/books/non_fictions/1/edit").to route_to("books/non_fictions#edit", :id => "1")
      end


      it "routes to #create" do
        expect(:post => "/books/non_fictions").to route_to("books/non_fictions#create")
      end

      it "routes to #update via PUT" do
        expect(:put => "/books/non_fictions/1").to route_to("books/non_fictions#update", :id => "1")
      end

      it "routes to #update via PATCH" do
        expect(:patch => "/books/non_fictions/1").to route_to("books/non_fictions#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/books/non_fictions/1").to route_to("books/non_fictions#destroy", :id => "1")
      end
    end
  end
end
