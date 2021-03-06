require "spec_helper"

RSpec.describe CalilApi::Library do

  before do
    allow_any_instance_of(CalilApi::Client).to receive(:appkey).and_return('lib_appkey')
  end

  let(:library) { CalilApi::Library.new }
  let(:expected_response) do
    { body: '{"status":"ok"}' }
  end
  context 'get list of libraries' do
    before do
      @expected_request = stub_request(:get, "https://api.calil.jp/library?appkey=lib_appkey&format=json&pref=%E5%9F%BC%E7%8E%89%E7%9C%8C").
         with(:headers => {'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"}).
         to_return(:status => 200, :body => fixture('library.json'), :headers => {})
    end

    it 'should return list of libraries in saitama' do
      libraries = CalilApi::Library.search(:pref => '埼玉県')
      expect(@expected_request).to have_been_made.once
      expect(libraries.size).to eq(3)
    end

    it 'should return 上尾市 for the first library returned' do
      libraries = CalilApi::Library.search(:pref => '埼玉県')
      expect(libraries[0].short).to eq('たちばな分館')
      expect(libraries[1].short).to eq('上尾市図書館')
      expect(libraries[2].short).to eq('上平公民館')
    end

    it 'should return Saitama_Ageo for the first library returned' do
      libraries = CalilApi::Library.search(:pref => '埼玉県')
      expect(libraries[0].systemid).to eq("Saitama_Ageo")
    end
  end

  context 'could not get list of libraries' do
    before do
      @expected_request = stub_request(:get, "https://api.calil.jp/library?appkey=lib_appkey&format=json&pref=%E5%AD%98%E5%9C%A8%E3%81%97%E3%81%AA%E3%81%84%E7%9C%8C").
         with(:headers => {'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"}).
         to_return(:status => 200, :body => "[]", :headers => {})
    end

    it 'should return empty list' do
      libraries = CalilApi::Library.search(:pref => '存在しない県')
      expect(libraries.size).to eq(0)
    end
  end
end
