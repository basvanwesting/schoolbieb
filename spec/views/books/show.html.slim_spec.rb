require 'rails_helper'

RSpec.describe "books/show", type: :view do
  before(:each) do
    @book = assign(:book, FactoryBot.create(:book))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/My First Book/)
  end
end
