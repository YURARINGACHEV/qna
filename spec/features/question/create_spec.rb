require 'rails_helper'

feature 'Use can create question', '
	In oreder to get question
	As an anuthenticated user
	I`d like to be able to ask the question
' do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
    end

    describe 'asks' do
      background do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Text text tex'
      end

      scenario 'a question' do
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Text text tex'
      end

      scenario 'a question with attached files' do
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unanuthenticated user tries to  asks a question' do
    visit questions_path

    expect(page).to_not have_content 'Ask'
  end

  describe 'multiple session', js: true do
    scenario 'User create question his can showed other user' do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end
      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end
    end
  end
end
