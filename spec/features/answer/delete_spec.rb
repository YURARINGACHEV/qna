require 'rails_helper'

feature 'User can delete own answer', %q{
  In order to delete answer
  As  Authenticated User
  I`d like to be able to delete own question
} do

  given(:bad_user) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  background { visit question_path(question) }

  scenario 'Authenticated user can delete own answer' do
    sign_in(user)
    visit question_path(answer.question)

    click_on "Delete answer"
 
    expect(page).to have_content "Answer deleted"
    expect(page).to_not have_content answer.body
  end

  scenario 'Other user can delete own answer' do
    sign_in(bad_user)
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content "Delete answer"
  end

  scenario 'Unauthenticated user can delete own questions' do
    visit question_path(question)

    expect(page).to have_content answer.body
    expect(page).to_not have_content "Delete answer"
  end
end