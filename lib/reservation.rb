require 'date'
require 'pry'

module Hotel
  class Reservation
    attr_reader :dates

    def initialize(input)
      validate_input(input)
      @dates = convert_dates(input)
    end

    def cost
      @dates.length * 200
    end

    def validate_input(input)
      if input == nil || input[0].class != String
        raise ArgumentError.new "Invalid date/s"
      end
    end

    def convert_dates(input)
      input.map { |date| date = Date.parse(date) }
    end
  end
end
