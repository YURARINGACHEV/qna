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

			before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

			it 'renders 200 status' do  		
		  	expect(response).to be_successful
		  end

		  it 'returns list ogf questions' do 
		  	expect(json.size).to eq 2
		  end

		  it 'returns all public fields' do
		    %w[title body user_id created_at updated_at].each do |attr|
          expect(json.first[attr]).to eq questions.first.send(attr).as_json
        end 
		  end
		end
	end
end