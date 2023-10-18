# frozen_string_literal: true

class NpmPkgSet
  def initialize(base, key, value)
    @base = base
    @key = key
    @value = value
  end

  def invoke!
    @base.run %(bin/npm pkg set "#{@key}"="#{@value}")
  end

  def revoke!
    @base.behavior = :invoke
    @base.run %(bin/npm pkg delete "#{@key}")
  ensure
    @base.behavior = :revoke
  end
end
