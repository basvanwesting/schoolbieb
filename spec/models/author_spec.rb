require 'rails_helper'

RSpec.describe Author, type: :model do

  context 'ransack id_author_wildcard' do
    let!(:author_1) { FactoryBot.create(:author, first_name: 'Kees', last_name: 'Vee')  }
    let!(:author_2) { FactoryBot.create(:author, first_name: 'Koos', last_name: 'Vee')  }
    let!(:author_3) { FactoryBot.create(:author, first_name: 'Vee',  last_name: 'Stál') }

    it 'searches' do
      expect(Author.ransack(id_author_wildcard: 'Kees Vee').result).to match_array [author_1]
      expect(Author.ransack(id_author_wildcard: 'vee').result).to match_array [author_1, author_2, author_3]
    end

    it 'searches accents' do
      expect(Author.ransack(id_author_wildcard: 'stal').result).to match_array [author_3]
      expect(Author.ransack(id_author_wildcard: 'stál').result).to match_array [author_3]
      expect(Author.ransack(id_author_wildcard: 'vée').result).to match_array [author_1, author_2, author_3]
    end

    it 'matches description' do
      expect(Author.ransack(id_author_wildcard: author_1.description).result).to match_array [author_1]
      expect(Author.ransack(id_author_wildcard: author_2.description).result).to match_array [author_2]
      expect(Author.ransack(id_author_wildcard: author_3.description).result).to match_array [author_3]
    end
  end
end
