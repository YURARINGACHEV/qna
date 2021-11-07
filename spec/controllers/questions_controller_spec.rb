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
