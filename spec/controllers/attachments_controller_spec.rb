require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:ohter_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:answer_files) { create(:answer, :files, question: question, user: user) }

  describe 'DELETE #delete_file' do
    before { login(user) }

    context 'User tries to delete file on his answer' do
      it 'deletes the file' do
        expect { delete :destroy, params: { id: answer_files.files[0] }, format: :js }.to change(answer_files.files, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer_files.files[0] }, format: :js
        expect(response).to redirect_to :destroy
      end
    end

    context 'Authorized other user' do
    	before { login(ohter_user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: answer_files.files[0] }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects the index' do
        delete :destroy, params: { id: answer_files.files[0] }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end