require 'rails_helper'

feature 'User can delete own question', %q{
  In order to delete question
  As  Authenticated User
  I`d like to be able to delete own question
} do

  given(:bad_user) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background { visit question_path(question) }

  scenario 'Authenticated user can delete own questions' do
    sign_in(user)
    visit question_path(question)

    click_on "Delete question"
 
    expect(page).to have_content "Question deleted"
    expect(page).to_not have_content question.title
  end

  scenario 'Other user can delete own questions' do
    sign_in(bad_user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_content "Delete question"
  end

  scenario 'Unauthenticated user can delete own questions' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_content "Delete question"
  end
end
