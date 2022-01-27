require 'rails_helper'

describe 'Questions Api', type: :request do
	let(:headers) { { "ACCEPT" => 'application/json' } }
  
  describe 'GET /api/v1/questions/me' do 
		context 'Unauthorized' do
  		it 'renders401 status if there is access_token' do 
	  		get '/api/v1/questions', headers: headers
		  	expect(response.status).to eq 401
		  end

		  it 'renders401 status if there is invalid' do 
			  get '/api/v1/questions', params: { access_token: '123' }, headers: headers
			  expect(response.status).to eq 401
		  end
		end

    context 'Authorized' do 
			let(:access_token) { create(:access_token) }
			let!(:questions) { create_list(:question, 2) }
			let(:question) { questions.first }
			let(:question_response) { json['questions'].first }
			let!(:answers) { create_list(:answer, 3, question: question) }

			before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

			it 'renders 200 status' do  		
		  	expect(response).to be_successful
		  end

		  it 'returns list ogf questions' do 
		  	expect(json['questions'].size).to eq 2
		  end

		  it 'returns all public fields' do
		    %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end 
		  end

		  it 'contains user object' do
		    expect(question_response['user']['id']).to eq question.user.id 
		  end

		  it 'contains short title' do
		    expect(question_response['short_title']).to eq question.title.truncate(7) 
		  end

		  describe 'answers' do 
		  	let(:answer) { answers.first }
		  	let(:answer_response) { question_response['answers'].first }

		  	it 'returns list ogf answers' do 
		  	  expect(question_response['answers'].size).to eq 3
		    end

		    it 'returns all public fields' do
		      %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end 
		    end
		  end
		end
	end
end