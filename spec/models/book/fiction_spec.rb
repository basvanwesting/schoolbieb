require 'rails_helper'

RSpec.describe Book::Fiction, type: :model do

  context 'validations' do
    it 'requires' do
      expect(subject.valid?).to be_falsey
      expect(subject.errors[:author]).to eq ["moet bestaan"]
      expect(subject.errors[:title]).to eq ["moet opgegeven zijn"]
      expect(subject.errors[:category]).to be_blank
    end
  end

end

