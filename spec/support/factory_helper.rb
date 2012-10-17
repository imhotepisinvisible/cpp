# /spec/support/factory_helpers.rb

module FactoryHelper
  def self.time_rand start = Time.now, finish = Time.now + 20.day.to_i
    Time.at(start.to_i + Random.rand(finish.to_i - start.to_i))
  end
end
