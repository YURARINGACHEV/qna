require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do 
    let(:questions) { create_list(:question, 3) } #задавать начальные данные.
                                                  #let создает метод questions 
    
    before { get :index }

    it 'populates an array of all questions' do 
      #questions = FactoryBot.create_list(:question, 3) #создать список  вопросов по шаблону factories/questions.rb
      # questions = create_list(:question, 3) #создаст список тестов
      expect(assigns(:questions)).to match_array(questions)
      #assigns - хэш всех инстанс переменных установленных в контроллере,
      #после вызова некоторого экшена
    end

    it 'renders index view' do 
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }#передаем параметр question.id 

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question #eq - проверка на эквивалент
    end

    it 'renders show view' do 
      expect(response).to render_template :show
    end
  end  

  describe 'GET #new' do 
    before { get :new }

    it 'assigns a new Question to @question' do 
      expect(assigns(:question)).to be_a_new(Question)#проверяем вопрос на новый объект класса Question
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do    
    before { get :edit, params: { id: question } }#передаем параметр question.id 

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question #eq - проверка на эквивалент
    end

    it 'renders edit view' do 
      expect(response).to render_template :edit
    end
  end 

  describe 'POST #create' do 
    #context задает условия
    context 'with valid attributes' do 
      it 'save a new question in the database' do 
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1) #attributes_for(:question)-выдае атрибуты из FactoryBot
      end
      it 'redirects to show view' do 
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do 
      it 'does not save the question' do 
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-renders new view' do 
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do 
    context 'with valid attributes' do 
      it 'assigns the requested question to @question' do 
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do 
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload 

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirects to updated question' do 
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do 
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }
      it 'does not save the question' do 
        question.reload 

        expect(question.title).to eq "MyString"
        expect(question.body).to eq "MyText"
      end
      it 're-renders edit view' do 
        expect(response).to render_template :edit
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
