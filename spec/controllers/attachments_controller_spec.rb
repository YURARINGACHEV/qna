require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:ohter_user) { create(:user) }
  let(:question_files) { create(:question, :question_files, user: user) }
  let!(:answer_files) { create(:answer, :answer_files, question: question_files, user: user) }

  describe 'DELETE #delete_file' do
    before { login(user) }
    describe 'Answer file' do
      context 'User tries to delete file on his answer' do
        it 'deletes the file' do
          expect do
            delete :destroy, params: { id: answer_files.files.first }, format: :js
          end.to change(answer_files.files, :count).by(-1)
        end

        it 'redirects to destroy' do
          delete :destroy, params: { id: answer_files.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'Authorized other user' do
        before { login(ohter_user) }

        it 'tries to delete file nswer' do
          expect do
            delete :destroy, params: { id: answer_files.files.first }, format: :js
          end.to_not change(answer_files.files, :count)
        end

        it 'redirects the destroy' do
          delete :destroy, params: { id: answer_files.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    describe 'Question file' do
      context 'User tries to delete file on his question' do
        it 'deletes the file' do
          expect do
            delete :destroy, params: { id: question_files.files.first },
                             format: :js
          end.to change(question_files.files, :count).by(-1)
        end

        it 'redirects to destroy' do
          delete :destroy, params: { id: question_files.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'Authorized other user' do
        before { login(ohter_user) }

        it 'tries to delete ' do
          expect do
            delete :destroy, params: { id: question_files.files.first }, format: :js
          end.to_not change(question_files.files, :count)
        end

        it 'redirects the destroy' do
          delete :destroy, params: { id: question_files.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end
  end
end
