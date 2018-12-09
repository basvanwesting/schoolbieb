require 'rails_helper'

RSpec.describe "books/new", type: :view do
  let(:author) { FactoryBot.create(:author) }
  before(:each) do
    assign(:book, Book.new(
      :name => "MyString",
      :reading_level => "MyString",
      :avi_level => "MyString",
      :author => author,
    ))
  end

  it "renders new book form" do
    render

    assert_select "form[action=?][method=?]", books_path, "post" do

      assert_select "input[name=?]", "book[name]"

      assert_select "input[name=?]", "book[reading_level]"

      assert_select "input[name=?]", "book[avi_level]"

      assert_select "input[name=?]", "book[author_id]"
    end
  end
end
