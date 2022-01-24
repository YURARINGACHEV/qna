require 'rails_helper'

feature 'The author can choose the best answer', "
  As the author of the question
  I would like to choose the best answer
" do
  given!(:other_user) { create(:user) }
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    scenario 'Author question can mark the best answer', js: true do
      sign_in(user)
      visit question_path(answer.question)

      expect(page).not_to have_content 'It is the best answer'

      click_on 'Mark as best'

      expect(page).to have_content 'It is the best answer'
    end

    scenario 'Other user cannot mark the best answer' do
      sign_in(other_user)

      visit question_path(question)

      expect(page).to_not have_link 'Mark as best'
    end
  end

  scenario 'Unauthenticated cannot mark the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end
