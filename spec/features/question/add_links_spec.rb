require 'rails_helper'

feature 'User can add linkes to question', %q{
  In order to provide additional info to my question
  As an question`s author
  I`d like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url_1) { 'https://url_1.com' }
  given(:url_2) { 'https://url_2.com' }
  given(:invalid_url) { 'invalid_url' }
  given(:gist_url) { 'https://gist.github.com/YURARINGACHEV/55a64b5b7480c90803dedd9cf586e8ac' }
  given(:question) { create(:question, user: user) }

  describe 'Add links to neew question' do
    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User add link when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'add link'

      fill_in 'Link name', with: 'My url 1'
      fill_in 'Url', with: url_1

      click_on 'Ask'

      expect(page).to have_link 'My url 1', href: url_1
    end

    scenario 'User add many links when asks question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'add link'

      fill_in 'Link name', with: 'My url 1'
      fill_in 'Url', with: url_1

      click_on 'add link'

      within page.all('.nested-fields')[1] do
        fill_in 'Link name', with: 'My url 2'
        fill_in 'Url', with: url_2
      end

      click_on 'Ask'

      expect(page).to have_link 'My url 1', href: url_1
      expect(page).to have_link 'My url 2', href: url_2
    end

    scenario 'User add link to gist when asks question', js: true do
  
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      fill_in 'Link name', with: 'gist'
      fill_in 'Url', with: gist_url
  
      click_on 'Ask'
  
      expect(page).to_not have_link 'gist', href: gist_url
    end

    scenario 'Invalid link for question', js: true do    
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'add link'

      fill_in 'Link name', with: 'My url 1'
      fill_in 'Url', with: invalid_url

      click_on 'Ask'

      expect(page).to have_content 'Links url is invalid'
    end
  end
  
  scenario 'The author of the question, when editing it, can new links', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do 
      click_on 'Edit question'

      click_on 'add link'

      fill_in 'Link name', with: 'My url 1'
      fill_in 'Url', with: url_1

      click_on 'Save question'
    end
    
    expect(page).to have_link 'My url 1', href: url_1
  end

  scenario 'User dlete link when edit question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    click_on 'add link'

    fill_in 'Link name', with: 'My url 1'
    fill_in 'Url', with: url_1

    click_on 'Ask'
    
    click_on 'delete link'

    expect(page).to_not have_link 'My url 1', href: url_1
  end
end