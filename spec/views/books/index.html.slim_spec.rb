require 'rails_helper'

RSpec.describe "books/index", type: :view do
  before(:each) do
    assign(:books, [
      FactoryBot.create(:book),
      FactoryBot.create(:book),

    ])
  end

  it "renders a list of books" do
    render
    assert_select "tr>td", :text => "My First Book".to_s, :count => 2
  end
end
