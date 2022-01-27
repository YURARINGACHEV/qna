shared_examples_for 'API Authorizable' do
  context 'Unauthorized' do
  	it 'renders401 status if there is access_token' do 
	  	do_request(method, api_path, headers: headers)
		 	expect(response.status).to eq 401
		 end

		it 'renders401 status if there is invalid' do 
		  do_request(method,api_path, params: { access_token: '123' }, headers: headers)
		  expect(response.status).to eq 401
		 end
	end
end

shared_examples_for 'Success requestable' do
  it 'return success status' do
    expect(response).to be_successful
  end
end
