require 'rails_helper'

feature 'User can sign out', '
	Authorized user can log out
' do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Authorized user can log out' do
    sign_in(user)
    expect(page).to have_content 'Log out'
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
