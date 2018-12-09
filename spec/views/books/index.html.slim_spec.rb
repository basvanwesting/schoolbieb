require 'rails_helper'

RSpec.describe "books/index", type: :view do
  before(:each) do
    assign(:books, [
      Book.create!(
        :name => "Name",
        :reading_level => "Reading Level",
        :avi_level => "Avi Level",
        :author => nil
      ),
      Book.create!(
        :name => "Name",
        :reading_level => "Reading Level",
        :avi_level => "Avi Level",
        :author => nil
      )
    ])
  end

  it "renders a list of books" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Reading Level".to_s, :count => 2
    assert_select "tr>td", :text => "Avi Level".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
