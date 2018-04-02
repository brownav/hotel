require 'date'
require 'pry'

module Hotel

  class Block
    attr_reader :id, :dates, :open_rooms, :booked_rooms

    def initialize(block)
      @id = block[:id]
      @dates = block[:dates]
      @open_rooms = block[:open_rooms]
      @booked_rooms = block[:booked_rooms]
    end

    def book_room
      @booked_rooms << @open_rooms.pop
    end
  end
end
