require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let(:user)  { create(:user) }
  let(:user2) { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }

  describe '#vote_up' do
    before { model.vote_up(user) }

    it 'user can vote up' do
      expect(model.rating).to eq(1)
    end

    it 'user un vote on the second attempt' do
      model.vote_up(user)
      expect(model.rating).to eq(1)
    end
  end

  describe '#vote_down' do
    before { model.vote_down(user) }

    it 'user can vote down' do
      expect(model.rating).to eq(-1)
    end

    it 'user un vote on the second attempt' do
      model.vote_down(user)
      expect(model.rating).to eq(-1)
    end
  end

  describe '#rating' do
    before { model.vote_up(user) }

    it 'resulting rating (difference between up and down votes)' do
      model.vote_down(user2)
      expect(model.rating).to eq(0)
    end
  end
end
