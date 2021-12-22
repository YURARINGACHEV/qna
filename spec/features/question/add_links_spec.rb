require 'rails_helper'

feature 'User can add linkes to question', %q{
  In order to provide additional info to my question
  As an question`s author
  I`d like to be able to add links
} do
  given(:user) { create(:user) }
  given(:url_1) { 'https://url_1.com' }
  given(:url_2) { 'https://url_2.com' }

  describe 'Add links to neew question'
    background do
      sign_in(user)
      visit new_question_path
    end


  scenario 'User add link when asks question' do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My url 1'
    fill_in 'Url', with: url_1

    click_on 'Ask'

    expect(page).to have_link 'My url 1', href: url_1
  end

  scenario 'User add many links when asks question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

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
end