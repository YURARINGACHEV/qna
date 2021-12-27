require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:reward) { create(:reward, question: question, user: user) }

  describe 'GET #index' do
    before { login(user) }
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'user has reward' do 
      expect(assigns(:rewards)).to eq([reward])
    end
  end
end