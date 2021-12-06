require 'rails_helper'

feature 'User can create answer', '
  An anuthenticated user
  can leave an answer
  to the question
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
 
      visit question_path(question)
    end

    describe 'answer' do 
      background do 
        fill_in 'Body', with: 'answer answer answer'
      end
      
      scenario 'answer to the question', js: true do
        fill_in 'Body', with: 'answer answer answer'
        click_on 'Answer'

        expect(current_path).to eq question_path(question)

        within '.answers' do
          expect(page).to have_content 'answer answer answer'
        end
      end

      scenario 'answer to the question with attached files', js: true do      
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Answer'
      
        within '.answers' do 
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'answer to the question with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unanuthenticated user tries  answer to the question' do
    visit question_path(question)
    
    expect(page).to_not have_link "Answer."
  end
end
