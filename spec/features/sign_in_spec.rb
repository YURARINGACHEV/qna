require 'rails_helper'

feature 'Use can sign in', '
	In oreder to ask questions
	As an unanuthenticated user
	I`d like to be able to sign in
' do
  # given(:user) { User.create!(email: 'user@test.com', password: '12345678') }  #элиас let
  given(:user) { create(:user) }

  background { visit new_user_session_path } # элиас before

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

  describe 'User tries to sign in with social networks' do
    before { visit new_user_session_path }

    describe 'with github' do
      scenario 'page has sign in link' do
        expect(page).to have_link 'Sign in with GitHub'
      end

      scenario 'user clicks to sign button' do
        OmniAuth.config.add_mock(:github, { uid: '12345', info: { email: 'test@mail.com' } })
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end

    describe 'with Vkontakte' do
      scenario 'page has sign in link' do
        expect(page).to have_link 'Sign in with Vkontakte'
      end

      scenario 'user clicks to sign button' do
        OmniAuth.config.add_mock(:vkontakte, { uid: '12345', info: { email: 'test2@mail.com' } })
        click_on 'Sign in with Vkontakte'

        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end
    end
  end
end
