require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) } # задавать начальные данные.
    # let создает метод questions

    before { get :index }

    it 'populates an array of all questions' do
      # questions = FactoryBot.create_list(:question, 3) #создать список  вопросов по шаблону factories/questions.rb
      # questions = create_list(:question, 3) #создаст список тестов
      expect(assigns(:questions)).to match_array(questions)
      # assigns - хэш всех инстанс переменных установленных в контроллере,
      # после вызова некоторого экшена
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } } # передаем параметр question.id

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question # eq - проверка на эквивалент
    end
    
    it 'assigns new link for aswer' do
      expect(assigns(:answer).links.first).to be_a_new(Link) # eq - проверка на эквивалент
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) } # support/controller_helpers

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question) # проверяем вопрос на новый объект класса Question
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } } # передаем параметр question.id

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question # eq - проверка на эквивалент
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    # context задает условия
    context 'with valid attributes' do
      it 'save a new question in the database' do
        # attributes_for(:question)-выдае атрибуты из FactoryBot
        expect do
          post :create, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not save the question' do
        question.reload
        expect(question.title).to eq 'Title'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user: user) }
    let!(:other_user) { create(:user) }
    let!(:other_question) { create(:question, user: other_user) }

    context 'Authorized user' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question.where(user: user), :count).by(-1)
      end

      it 'redirects the index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'Authorized other user' do
      it 'deletes the question' do
        expect { delete :destroy, params: { id: other_question } }.to_not change(Question, :count)
      end

      it 'redirects the index' do
        delete :destroy, params: { id: other_question }
        expect(response).to redirect_to questions_path
      end
    end
  end
  # describe 'GET #index' do
  #   it 'populates an array of all questions' do
  #     question1 = FactoryBot.create(:question) #создать вопрос по шаблону factories/questions.rb
  #     question2 = FactoryBot.create(:question)

  #     get :index

  #     expect(assigns(:questions)).to match_array([question1, question2])
  #     #assigns - хэш всех инстанс переменных установленных в контроллере,
  #     #после вызова некоторого экшена
  #   end

  #   it 'renders index view' do
  #     get :index
  #     expect(response).to render_template :index
  #   end
  # end
end
