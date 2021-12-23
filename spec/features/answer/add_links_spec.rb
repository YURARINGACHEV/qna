require 'rails_helper'

feature 'User can add linkes to answer', %q{
	In order to provide additional info to my question
	As an question`s author
	I`d like to be able to add links
} do
	given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:url_1) { 'https://url_1.com' }
  given(:url_2) { 'https://url_2.com' }
  given(:invalid_url) { 'invalid_url' }

  describe 'Add links to neew question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

	  scenario 'User add link when given an answer', js: true do    
      fill_in 'Body', with: 'answer answer answer'

      click_on 'add link'

      fill_in 'Link name', with: 'My url 1'
      fill_in 'Url', with: url_1

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'My url 1', href: url_1
      end  
    end

    scenario 'User add many links when given an answer', js: true do
      fill_in 'Body', with: 'answer answer answer'

      click_on 'add link'

      fill_in 'Link name', with: 'My url 1'
      fill_in 'Url', with: url_1

      click_on 'add link'

      within page.all('.nested-fields')[1] do
        fill_in 'Link name', with: 'My url 2'
        fill_in 'Url', with: url_2
      end

      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'My url 1', href: url_1
        expect(page).to have_link 'My url 2', href: url_2
      end 
    end

    scenario 'Invalid link for answer', js: true do    
      fill_in 'Body', with: 'answer answer answer'

      click_on 'add link'

      fill_in 'Link name', with: 'My url 1'
      fill_in 'Url', with: invalid_url

      click_on 'Answer'

      expect(page).to have_content 'Links url is invalid'
    end
  
    scenario 'The author of the auhtor, when editing it, can new links', js: true do
      fill_in 'Body', with: 'answer answer answer'

      click_on 'Answer'

      within '.answer' do 
        click_on 'Edit answer'

        click_on 'add link'

        fill_in 'Link name', with: 'My url 1'
        fill_in 'Url', with: url_1

        click_on 'Save'
      end
    
      expect(page).to have_link 'My url 1', href: url_1
    end
  end
end