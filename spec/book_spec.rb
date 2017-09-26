require "spec_helper"

RSpec.describe CalilApi::Book do
  before do
    allow_any_instance_of(CalilApi::Client).to receive(:appkey).and_return('book_appkey')
  end
  let(:book) { CalilApi::Book.new }
  let(:expected_response) do
    { body: '{"status":"ok"}' }
  end

  context 'get list of libraries' do
    before do
      @expected_request = stub_request(:get, "https://api.calil.jp/check?appkey=book_appkey&format=json&systemid=Tokyo_Setagaya,Aomori_Pref&isbn=4334926940").
         with(:headers => {'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"}).
         to_return(:status => 200, :body => fixture('two_books2.json'), :headers => {})
    end

    it 'should return list of books matching isbn in that library' do
      result = book.search(['4334926940'], ['Tokyo_Setagaya','Aomori_Pref'])
      expect(@expected_request).to have_been_made.once
      expect(result.size).to eq(1)
    end
  end
end
