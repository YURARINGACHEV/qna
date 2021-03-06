require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'Authenticated user save a new answer in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) },
                        format: :js
        end.to change(question.answers.where(user: user), :count).by(1)
      end

      it 'renders to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'Authenticated user does not save the answer' do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(Answer, :count)
      end

      it 'renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    before { login user }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe '#mark_as_best', js: true do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:reward) { create :reward, question: answer.question }

    before do
      login user
      post :mark_as_best, params: { id: answer }, format: :js
      answer.reload
    end

    it 'makes the answer as best' do
      post :mark_as_best, params: { id: answer }, format: :js
      expect(assigns(:answer)).to be_best
    end

    it 'gives to answers author a reward' do
      expect(answer.question.reward.user).to eq answer.user
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user: user) }
    let!(:other_user) { create(:user) }
    let!(:other_answer) { create(:answer, question: question, user: other_user) }

    context 'Authorized user' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects the index' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authorized other user' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: other_answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects the index' do
        login other_user
        delete :destroy, params: { id: other_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
