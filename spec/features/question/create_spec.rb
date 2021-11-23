require 'rails_helper'

feature 'Use can create question', %q{
	In oreder to get answer from community
	As an anuthenticated user
	I`d like to be able to ask the question
} do

  given(:user) { User.create!(email: 'user@test.com', password: '12345678') } 

  scenario 'Anuthenticated user asks a question' do
  	visit visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Text text tex'
    click_on 'Ask'


    expect(page).to have_content "Your question successfully created."
    expect(page).to have_content "Test question"
    expect(page).to have_content "Text text tex"
  end 
  scenario 'Anuthenticated user asks a question with errors' do
  	visit visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask question'

    click_on 'Ask'
    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Unanuthenticated user tries to  asks a question' do
  	visit questions_path
    click_on 'Ask question'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end