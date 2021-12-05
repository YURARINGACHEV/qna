require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do 
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'validations' do  
    it { should validate_presence_of :body }
  end

  describe 'best answer' do 
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
        
    it 'set answer as a best' do
      answer.mark_as_best
      expect(answer).to be_best
    end
  end
end
