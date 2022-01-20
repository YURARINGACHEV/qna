require 'rails_helper'

feature 'Use can sign in', '
	In oreder to ask questions
	As an unanuthenticated user
	I`d like to be able to sign in
' do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    
    open_email('user@test.ru')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
