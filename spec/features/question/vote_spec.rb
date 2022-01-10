require 'rails_helper'

feature 'User can vote for a answer', %q{
  In order to show that answer is good
  As an authenticated user
  I'd like to be able to vote
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User is not an author of question', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up for question' do
      within ".question" do
        click_on 'vote up'

        within '.vote-score' do
          expect(page).to have_content '1'
        end
      end
    end
  end
end