shared_examples_for 'API Authorizable' do
  context 'Unauthorized' do
  	it 'renders401 status if there is access_token' do 
	  	do_request(method, api_path, headers: headers)
		 	expect(response.status).to eq 401
		 end

		it 'renders401 status if there is invalid' do 
		  do_request(method, api_path, params: { access_token: '123' }, headers: headers)
		  expect(response.status).to eq 401
		 end
	end
end

shared_examples_for 'Success requestable' do
  it 'return success status' do
    expect(response).to be_successful
  end
end

shared_examples 'Resource count returnable' do
  it 'returns list of resources' do
    expect(resource_response.size).to eq resource.size
  end
end

shared_examples 'Public fields returnable' do
  it 'return all public fields' do
    attrs.each do |attr|
      expect(resource_response[attr]).to eq resource.send(attr).as_json
    end
  end
end