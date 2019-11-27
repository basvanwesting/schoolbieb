require 'rails_helper'

RSpec.describe Book::NonFiction, type: :model do

  context 'validations' do
    it 'requires' do
      expect(subject.valid?).to be_falsey
      expect(subject.errors[:author]).to be_blank
      expect(subject.errors[:title]).to eq ["moet opgegeven zijn"]
      expect(subject.errors[:category]).to eq ["moet opgegeven zijn"]
    end
  end

end

