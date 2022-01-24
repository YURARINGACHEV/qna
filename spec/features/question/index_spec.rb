require 'rails_helper'

feature 'User can view a list of questions', '
  In order to get answer to my problem
  As  any User
  I want to be able to view questions list
' do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  background { visit questions_path }

  scenario 'Authenticated user can view a list of questions' do
    sign_in(user)
    expect(page).to have_content('Title', count: 3)
    expect(page).to have_content('MyText', count: 3)
  end

  scenario 'Unauthenticated user can view a list of questions' do
    expect(page).to have_content('Title', count: 3)
    expect(page).to have_content('MyText', count: 3)
  end
end
