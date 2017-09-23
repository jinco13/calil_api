require "spec_helper"

RSpec.describe CalilApi do
  let(:endpoint){ 'https://dummy.api.com' }
  it "has a version number" do
    expect(CalilApi::VERSION).not_to be nil
  end
end
