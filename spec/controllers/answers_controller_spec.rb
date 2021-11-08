require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  # let(:answer) { question.answers.create(attributes_for(:answer)) }
  let(:answer) { create(:answer, question: question) }

   describe 'GET #new' do 
    before { get :new, params: { question_id: answer.question }}

    it 'assigns a new answer to @answer' do 
      expect(assigns(:answer)).to be_a_new(Answer)#проверяем вопрос на новый объект класса Question
    end

    it 'renders new view' do 
      expect(response).to render_template :new
    end
  end

  # describe 'POST #create' do 
  #   #context задает условия
  #   context 'with valid attributes' do 
  #     it 'save a new question in the database' do 
  #       expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1) #attributes_for(:question)-выдае атрибуты из FactoryBot
  #     end
  #     it 'redirects to show view' do 
  #       post :create, params: { question: attributes_for(:question) }
  #       expect(response).to redirect_to assigns(:question)
  #     end
  #   end

  #   context 'with invalid attributes' do 
  #     it 'does not save the question' do 
  #       expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
  #     end
  #     it 're-renders new view' do 
  #       post :create, params: { question: attributes_for(:question, :invalid) }
  #       expect(response).to render_template :new
  #     end
  #   end
  # end

end


# let(:answer) { question.answers.create(attributes_for(:answer)) }

# Привет. Если нужно, чтобы ответ принадлежал конкретному вопросу.

# let(:question) { create(:question) }
# let(:answer) { create(:answer, question: question }
# Если нет, то при наличии связи в фабрике

#  factory :answer do
#     body { FactoryGirl.generate(:answer_body) }
#     question
#     user
#  end
# можно вызывать let(:answer) { create(:answer) }

# столкнулся с тем, что вложенный роутинг ответов через shallow: true

# делает answer_path - для show, edit, update, destroy

# а для index,create - question_answers_path

# Именно так он и должен работать, для этого и есть опция shallow. А с чем ты ожидал столкнуться, когда ее применял?

# change(question.answers, :count).by(1)

# Здесь в другом проблема. Нужно сделать ресурс ответов вложенным в ресурс вопроса и передавать question_id в параметрах, 
# НЕ вкладывая его в answers, т.е. так должно быть примерно:
# params: { question_id: question, answer: { .... } }
# а в контроллере сначала по question_id загрузить вопрос и создать ответ, свяазнный с вопросом (через ассоциации).

# patch :update, id: answer, question_id: answer.question_id, answer: attributes_for(:answer)

# Подтверждаю, в случае shallow передавать question_id нужно только для new, index и create, 
# тк в них нет еще объекта, связанного с родительским. В остальных экшеназ можно получить
#  вопрос из ответа и это будет правильно, тк мы точно берем нужный вопрос. В случае со скрытым
#   полем очень легко отправить неправильные данные в контроллер.
# И вообще, в большинстве случаев, передача параметров через скрытые поля - очень плохая идея, тк это не безопасно.


# Я смотрю многие пишут в спеках:
# expect(response).to redirect_to question_path(assigns(:question))
# Можно же покороче:
# expect(response).to redirect_to assigns(:question)



# require ‘rails_helper’

# describe AnswersController do
# let(:question) { create(:question) }
# let(:answer) { create(:answer) }

# describe ‘POST #create’ do
# context ‘with valid attributes’ do
# it ‘saves new answer in database’ do
# expect { post :create, question: attributes_for(:question), answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
# end

#   it 'redirects to it\'s own question' do
#     post :create, question_id: question, answer: attributes_for(:answer)
#     expect(response).to redirect_to question
#   end
# end

# context 'with invalid attributes' do
#   it 'does not save the answer' do
#     expect { post :create, question_id: question, answer: attributes_for(:answer) }.to_not change(Answer, :count)
#   end
# end
# end
# end