require "multi_type/version"

module MultiType
  extend self

  autoload :Group, "multi_type/group"

  def [](*args)
    Group.new(args).to_module
  end
end
