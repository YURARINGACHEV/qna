require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it 'User is author of question' do
    expect(user).to be_author(question)
  end

  it 'User is author of answer' do
    expect(user).to be_author(answer)
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe 'user subscribed?' do
    let(:second_user) { create(:user) }
    let(:subscription) { create(:subscription, question: question, user: user) }

    it 'is true' do
      expect(subscription.user).to be_subscribed(subscription.question)
    end

    it 'is false' do
      expect(second_user).to_not be_subscribed(question)
    end
  end
end
