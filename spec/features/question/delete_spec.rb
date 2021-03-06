require 'rails_helper'

feature 'User can delete own question', '
  In order to delete question
  As  Authenticated User
  I`d like to be able to delete own question
' do
  given(:bad_user) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background { visit question_path(question) }

  scenario 'Authenticated user can delete own questions' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Question deleted'
    expect(page).to_not have_content question.title
  end

  scenario 'Is author can delete file', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Edit question'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Save question'
    end

    expect(page).to have_link 'rails_helper.rb'
    click_on 'Delete file'
    expect(page).to_not have_link 'rails_helper.rb'
  end

  scenario 'Other user can delete own questions' do
    sign_in(bad_user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Unauthenticated user can delete own questions' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to_not have_link 'Delete question'
  end
end
