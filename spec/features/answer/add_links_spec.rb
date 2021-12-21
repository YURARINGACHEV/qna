require 'rails_helper'

feature 'User can add linkes to answer', %q{
	In order to provide additional info to my question
	As an question`s author
	I`d like to be able to add links
} do
	given(:user) { create(:user) }
  given(:question) { create(:question) }
	given(:gist_url) { 'https://gist.github.com/YURARINGACHEV/c65a114fac192ae484e5e8dad80cdd5a' }

	scenario 'User add link when asks question' do
    sign_in(user)

    visit question_path(question)
    
    fill_in 'Body', with: 'answer answer answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end  
  end
end