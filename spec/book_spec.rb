require "spec_helper"

RSpec.describe CalilApi::Book do
  before do
    allow_any_instance_of(CalilApi::Client).to receive(:appkey).and_return('book_appkey')
  end
  let(:book) { CalilApi::Book.new }
  let(:expected_response) do
    { body: '{"status":"ok"}' }
  end

  context 'get list of available libraries using one book' do
    before do
      @expected_request = stub_request(:get, "https://api.calil.jp/check?appkey=book_appkey&format=json&systemid=Tokyo_Setagaya&isbn=4834000826").
         with(:headers => {'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"}).
         to_return(:status => 200, :body => fixture('book_available.json'), :headers => {})
    end

    it 'should return books with systems' do
      result = book.search(['4834000826'], ['Tokyo_Setagaya'])
      expect(@expected_request).to have_been_made.once
      expect(result[0].libraries[0].id).to eq("Tokyo_Setagaya")
    end

    it 'should return number of books in system' do
      result = book.search(['4834000826'], ['Tokyo_Setagaya'])
      expect(@expected_request).to have_been_made.once
      expect(result[0].libraries[0].total).to eq(19)
    end

    it 'should return number of available books in system' do
      result = book.search(['4834000826'], ['Tokyo_Setagaya'])
      expect(@expected_request).to have_been_made.once
      expect(result[0].libraries[0].available).to eq(13)
    end

    it 'should return true if reservable' do
      result = book.search(['4834000826'], ['Tokyo_Setagaya'])
      expect(@expected_request).to have_been_made.once
      expect(result[0].reservable?).to eq(true)
    end
  end

  context 'get list of available libraries using one book' do
    before do
      @expected_request = stub_request(:get, "https://api.calil.jp/check?appkey=book_appkey&format=json&systemid=Aomori_Pref,Tokyo_Setagaya&isbn=4834000826").
         with(:headers => {'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"}).
         to_return(:status => 200, :body => fixture('one_book_2lib.json'), :headers => {})
    end

    it 'should return books with systems' do
      result = book.search(['4834000826'], ['Aomori_Pref', 'Tokyo_Setagaya'])
      expect(@expected_request).to have_been_made.once
      expect(result[0].libraries.size).to eq(2)
    end
  end

  context 'get list of libraries' do
    before do
      @expected_request = stub_request(:get, "https://api.calil.jp/check?appkey=book_appkey&format=json&systemid=Tokyo_Setagaya,Aomori_Pref&isbn=4334926940,4834000826").
         with(:headers => {'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"}).
         to_return(:status => 200, :body => fixture('two_books2.json'), :headers => {})
    end

    it 'should return list of books matching isbn in that library' do
      result = book.search(['4334926940','4834000826'], ['Tokyo_Setagaya','Aomori_Pref'])
      expect(@expected_request).to have_been_made.once
      expect(result.size).to eq(2)
    end
  end

  context 'when there is no available book' do
    before do
      @expected_request = stub_request(:get, "https://api.calil.jp/check?appkey=book_appkey&format=json&systemid=Tokyo_Setagaya&isbn=4334926940").
         with(:headers => {'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"}).
         to_return(:status => 200, :body => fixture('book_unavailable.json'), :headers => {})
    end

    it 'should return false when reservable? is called' do
      result = book.search(['4334926940'], ['Tokyo_Setagaya'])
      expect(@expected_request).to have_been_made.once
      expect(result[0].reservable?).to eq(false)
    end
  end

  context 'when book search is taking long time' do
    before do
      @expected_request = stub_request(:get, "https://api.calil.jp/check?appkey=book_appkey&format=json&systemid=Tokyo_Setagaya&isbn=4334926940").
         with(:headers => {'User-Agent' => "CalilApi v#{CalilApi::VERSION}(ruby-#{RUBY_VERSION} [#{RUBY_PLATFORM}])"}).
         to_return(
          {
            :status => 200, :body => fixture('book_continue.json'), :headers => {}
            },
          {
            :status => 200, :body => fixture('book_continue_finish.json'), :headers => {}
            })
    end

    it 'should return false when reservable? is called' do
      result = book.search(['4334926940'], ['Tokyo_Setagaya'])
      expect(@expected_request).to have_been_made.twice
      expect(result[0].reservable?).to eq(true)
    end
  end
end
