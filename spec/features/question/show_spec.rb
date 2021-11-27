require 'rails_helper'

feature 'User can view the question and the answers to it', "
  In order to get answer from a community
  As any user
  I'd like to be able to view question and answers to it
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Authenticate user can view the question and the answers to it' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario 'Unauthenticate user can view the question and the answers to it' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
