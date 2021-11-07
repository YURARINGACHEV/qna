require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

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
    let(:question) { create(:question) }
    
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
    let(:question) { create(:question) }
    
    before { get :edit, params: { id: question } }#передаем параметр question.id 

    it 'assigns the requested question to @question' do 
      expect(assigns(:question)).to eq question #eq - проверка на эквивалент
    end

    it 'renders edit view' do 
      expect(response).to render_template :edit
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
