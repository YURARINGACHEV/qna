require 'sphinx_helper'

feature 'User can make search', "
  In order to find something
  As a User
  I'd like to be able to make search
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create :answer, user: user, question: question }

  describe 'User make correct search' do
    background do
      visit questions_path
    end

    scenario 'for all types', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in :body, with: 'empty result'
          select 'Global search', from: :type
          click_on 'Search'
        end

        expect(page).to have_content 'No Result'
      end
    end

    scenario ' for Global search types', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in :body, with: question.title
          select 'Global search', from: :type

          click_on 'Search'
        end
        expect(page).to have_content question.title
      end
    end

    scenario 'for question type', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in :body, with: question.title
          select 'Question', from: :type

          click_on 'Search'
        end

        expect(page).to have_content question.title
      end
    end

    scenario 'for answer type', sphinx: true, js: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in :body, with: answer.body
          select 'Answer', from: :type

          click_on 'Search'
        end

        expect(page).to have_content answer.body
      end
    end
  end
end 