require 'rails_helper'

feature 'Use can sign in', %q{
	In oreder to ask questions
	As an unanuthenticated user
	I`d like to be able to sign in
} do

	given(:user) { User.create!(email: 'user@test.com', password: '12345678') }  #элиас let
  
  background { visit visit new_user_session_path } #элиас before

	scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    # save_and_open_page открывае страницу в браузуре
    expect(page).to have_content 'Signed in successfully.'
	end

	scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
	end
end