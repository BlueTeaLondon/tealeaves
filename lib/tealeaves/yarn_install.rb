# frozen_string_literal: true

class YarnInstall
  def initialize(base, dependencies, flags)
    @base = base
    @dependencies = dependencies.join(" ")
    @flags = flags
  end

  def invoke!
    @base.run "bin/yarn add #{@dependencies} #{@flags}"
  end

  def revoke!
    @base.behavior = :invoke
    @base.run "bin/yarn remove #{@dependencies}"
  ensure
    @base.behavior = :revoke
  end
end
