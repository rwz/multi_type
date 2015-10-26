require "multi_type"

RSpec::Matchers.define :be_of_type do |expected|
  match do |actual|
    expected === actual
  end

  failure_message do |actual|
    "#{actual} does not match type #{expected}"
  end
end
