require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to show that question is good
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

    scenario 'you cannot vote multiple times' do
      within ".question" do
        click_on 'vote up'
        click_on 'vote up'

        within '.vote-score' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'unvote his vote' do
      within ".question" do
        click_on 'vote up'
        click_on 'unvote'

        within '.vote-score' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'votes down for question' do
      within ".question" do
        click_on 'vote down'

        within '.vote-score' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'you can not vote multiple times' do
      within ".question" do
        click_on 'vote down'
        click_on 'vote down'

        within '.vote-score' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'can re-votes' do
      within ".question" do
        click_on 'vote up'
        click_on 'unvote'
        click_on 'vote down'

        within '.vote-score' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'User is author of question tries to', js: true do
    scenario 'Author not have view links' do
      sign_in(author)
      visit question_path(question)

      expect(page).to_not have_content 'vote up'
      expect(page).to_not have_content 'vote down'
      expect(page).to_not have_content 'unvote'
    end
  end

  describe 'Unauthorized user tries to' do
    scenario 'User not have view links' do
      visit question_path(question)

      expect(page).to_not have_content 'vote up'
      expect(page).to_not have_content 'vote down'
      expect(page).to_not have_content 'unvote'
    end
  end
end 