require "spec_helper"

RSpec.describe CalilApi do
  let(:endpoint){ 'https://dummy.api.com' }
  let(:appkey){ 'dummy_appkey' }
  let(:client) { CalilApi::Client.new(endpoint) }
  let(:library) { CalilApi::Library.new }
  let(:expected_query) do
    { appkey: appkey, format: 'json' }
  end
  let(:expected_response) do
    { body: '{"status":"ok"}' }
  end

  it "has client class" do
    client = CalilApi::Client.new(endpoint)
    expect(client).not_to be nil
  end

  describe '#get' do
    before do
      allow(client).to receive(:appkey).and_return(appkey)
      @expected_request = stub_request(:get, endpoint).
        with(query: expected_query,
           headers: { 'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])" }).
           to_return(expected_response)
    end

    context 'call get without any parameters' do
      before do
        client.get({})
      end

      specify 'call endpoint with default parameters' do
        expect(@expected_request).to have_been_made.once
      end
    end
  end
end
