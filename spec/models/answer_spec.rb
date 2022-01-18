require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do 
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end
  
  it { should accept_nested_attributes_for :links }

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

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
