require 'rails_helper'

shared_examples_for 'voted' do

  let(:user) { create(:user) }
  let(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: user) }

  describe "POST #vote" do
    context "Not author" do
      before { login(user) }

      it 'user can vote up for resource' do
        expect { post :vote_up, params: { id: model.id } }.to change(model.votes, :count).by(1)
        expect(model.rating).to eq 1
      end

      it 'user cant vote up double once for resource' do
        expect { post :vote_up, params: { id: model.id } }.to change(model.votes, :count).by(1)
        expect(model.rating).to eq 1
        expect { post :vote_up, params: { id: model.id } }.to_not change(model.votes, :count)
      end

      it 'user can vote down for model' do
        expect { post :vote_down, params: { id: model.id } }.to change(model.votes, :count).by(1)
        expect(model.rating).to eq -1
      end

      it 'user can vote clear of model' do
        @vote = model.votes.create(value: 1, user: user)

        expect { delete :unvote, params: { id: model.id } }.to change(model.votes, :count).by(-1)
        expect(model.votes.count).to eq 0
      end
    end

    context "Author" do
      before { sign_in(user) }

      it 'author cant vote up for model' do
        default_rating = model.rating
        expect { post :vote_up, params: { id: model.id } }.to_not change(model.votes, :count)
        expect(model.rating).to eq default_rating
      end

      it 'author cant vote down for model' do
        default_rating = model.rating
        expect { post :vote_down, params: { id: model.id } }.to_not change(model.votes, :count)
        expect(model.rating).to eq default_rating
      end

      it 'author cant vote clear of model' do
        @vote = model.votes.create(value: 1, user: user)
        current_rating = model.rating

        expect { delete :unvote, params: { id: model.id } }.to_not change(model.votes, :count)
        expect(model.rating).to eq current_rating
      end
    end

    context "Guest" do
      it 'guest cant vote up for model' do
        default_rating = model.rating
        expect { post :vote_up, params: { id: model.id } }.to_not change(model.votes, :count)
        expect(model.rating).to eq default_rating
      end

      it 'guest cant vote down for model' do
        default_rating = model.rating
        expect { post :vote_down, params: { id: model.id } }.to_not change(model.votes, :count)
        expect(model.rating).to eq default_rating
      end

      it 'guest cant vote clear of model' do
        @vote = model.votes.create(value: 1, user: user)
        current_rating = model.rating

        expect { delete :unvote, params: { id: model.id } }.to_not change(model.votes, :count)
        expect(model.rating).to eq current_rating
      end
    end
  end
end
