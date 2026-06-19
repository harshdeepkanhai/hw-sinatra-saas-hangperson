require 'webmock/cucumber'

Before do
  stub_request(:get, /api\.datamuse\.com/).to_return(:status => 200, :headers => {}, :body => '[{"word":"testword"}]')
end
