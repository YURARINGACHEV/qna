require 'rails_helper'

feature 'The author can choose the best answer', "
  As the author of the question
  I would like to choose the best answer
" do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }

  describe 'Authenticated user' do
    scenario 'Author question can mark the best answer', js: true do
      sign_in(user)
      visit question_path(question)

      within ".answer[data-answer-form-id='#{answer.id}']" do
        expect(page).not_to have_content 'Best answer'
        click_on 'Mark as best'
        expect(page).to have_content 'Best answer'
      end
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