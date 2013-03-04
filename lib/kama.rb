require "kama/version"
require 'forwardable'
require 'csv'

class Kama
  extend Forwardable

  # @param data Either a AR class, or collection of AR objects.
  # @return [String] A csv-string containing all the data given (defaulting to #all)
  def self.dump(data, *args)
    if data.is_a?(Class)
      new(data, data.all)
    else
      new(data.class, data)
    end.to_csv(*args)
  end

  def initialize(klass, data)
    @klass = klass
    @data = data
  end
  delegate :column_names => :@klass

  def to_csv(io = "")
    io << CSV.generate do |output|
      output << column_names

      @data.each do |obj|
        output << column_names.map { |c| obj.send(c) || '' }
      end
    end
  end
end
