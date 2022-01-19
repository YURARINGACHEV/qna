require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

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

    context 'user already' do 
      it 'returns the user' do 
        user.authorizations.create(provider: 'github', uid: '123')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do 
      context 'user already exists' do 
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: user.email }) }
        it 'does not create new user' do 
          expect { User.find_for_oauth(auth) }.to_not change(User, :count) 
        end

        it 'create authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1) 
        end

        it 'create authorization with provider ans uid' do 
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exists' do 
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: 'new@user.com' }) }
        
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
        
        it 'returns new user' do 
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do 
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do 
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do 
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end 
    end
  end

  # describe '.find_for_oauth' do
  #   let!(:user) { create(:user) }
  #   let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
  #   let(:service) { double('Services::FindForOauth') }

  #   it 'calls Services::FindForOauth' do
  #     expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
  #     expect(service).to receive(:call)
  #     User.find_for_oauth(auth)
  #   end
  # end
end
