require 'spec_helper'

describe 'HOME' do
	it "loads homepage" do
		get '/'
		expect(last_response).to be_ok
	end
end
