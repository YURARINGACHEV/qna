require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    context 'Authorized user' do
      before { login(user) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized other user' do
      before { login(other_user) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(question.links, :count)
      end

      it 'redirects the index' do
        delete :destroy, params: { id: link }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
