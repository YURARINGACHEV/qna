require 'rails_helper'

describe Ability do 
  subject(:ability) { Ability.new(user) }
  
  describe 'for quest' do 
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
  	let(:user) { create :user }
  	let(:other_user) { create :user }

  	let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }

    let(:answer) { create(:answer, question: question, user: user) }
    let(:other_answer) { create(:answer, question: question, user: other_user) }
    
  	it { should_not be_able_to :manage, :all }
  	it { should be_able_to :read, Question }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user), user: user }
    it { should_not be_able_to :update, create(:question, user: other_user), user: user }

    it { should be_able_to :update, create(:answer, user: user), user: user }
    it { should_not be_able_to :update, create(:answer, user: other_user), user: user }

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :destroy, Answer }

      it { should be_able_to :update, create(:answer, user: user, question: question) }
      it { should_not be_able_to :update, create(:answer, user: other_user, question: other_question) }

      it { should be_able_to :mark_as_best, create(:answer, user: user, question: question) }
      it { should_not be_able_to :mark_as_best, create(:answer, user: other_user, question: other_question) }

      it { should_not be_able_to [:vote_up, :vote_down, :unvote], create(:answer, user: user, question: question) }
      it { should be_able_to [:vote_up, :vote_down, :unvote], create(:answer, user: other_user, question: other_question) }
    end

     context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :destroy, Question }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should_not be_able_to [:vote_up, :vote_down, :unvote], question }
      it { should be_able_to [:vote_up, :vote_down, :unvote], other_question }

      it { should_not be_able_to [:vote_up, :vote_down, :unvote], create(:question, user: user) }
      it { should be_able_to [:vote_up, :vote_down, :unvote], create(:question, user: other_user) }
    end

    context 'when comment question and answer' do
      let(:question_comment) 				{ create :comment, commentable: question, user: user }
      let(:second_question_comment) { create :comment, commentable: question, user: other_user }

      let(:answer_comment) 					{ create :comment, commentable: answer, user: user }
      let(:second_answer_comment) 	{ create :comment, commentable: answer, user: other_user }

      it { should be_able_to :create, Comment }

      it { should    be_able_to :update, question_comment, user: user }
      it { should_not be_able_to :update, second_question_comment, user: user }

      it { should     be_able_to :destroy, question_comment, user: user }
      it { should_not be_able_to :destroy, second_question_comment, user: user }

      it { should    be_able_to :update, answer_comment, user: user }
      it { should_not be_able_to :update, second_answer_comment, user: user }

      it { should     be_able_to :destroy, answer_comment, user: user }
      it { should_not be_able_to :destroy, second_answer_comment, user: user }
    end

    context 'Link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

      it { should be_able_to :destroy, create(:link, linkable: answer) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_answer) }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, ActiveStorage::Attachment }
    end
  end
end



















