require 'rails_helper'

feature 'User can edit his answer', %{
  In order to correct mistakes
  As an author of answer
  i`d like to be able to edit answer
} do

  given(:bad_user) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do
    describe 'Authenticated user' do
      scenario 'edits his answer', js: true do
        sign_in(user)
 
        visit question_path(question)

        click_on 'Edit answer'

        within '.answers' do 
          fill_in "Your answer", with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his answer with errors', js: true do
        sign_in(user)

        visit question_path(question)

        click_on 'Edit answer'

        within '.answers' do 
          fill_in "Your answer", with: ''
        
          click_on 'Save'

          expect(page).to have_content "Body can't be blank"
        end
      end  
    end

    scenario "tries to edits other user`s question" do 
      sign_in(bad_user)
      visit question_path(question)

      expect(page).to have_content answer.body
      expect(page).to_not have_link 'Edit answer'
    end
  end
  
  scenario 'Unauthenticated can not edit answer' do 
    visit question_path(question)
    
    expect(page).to_not have_link "Edit answer"
  end
end