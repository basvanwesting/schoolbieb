require 'rails_helper'

RSpec.describe "books/show", type: :view do
  before(:each) do
    @book = assign(:book, Book.create!(
      :name => "Name",
      :reading_level => "Reading Level",
      :avi_level => "Avi Level",
      :author => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Reading Level/)
    expect(rendered).to match(/Avi Level/)
    expect(rendered).to match(//)
  end
end
