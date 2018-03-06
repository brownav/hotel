require_relative 'reservation'
require_relative 'room'
require 'date'
require 'pry'

module Hotel
  class Admin
    attr_reader :free_rooms, :reservations, :booked_rooms

    def initialize
      @reservations = []
      @free_rooms = room_list
      @booked_rooms = []
    end

    def room_list
      rooms = []
      (1..20).each { |i| rooms << i = Hotel::Room.new(i) }
      return rooms
    end

    def book_room(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Can only use reservation instance to book a room")
      end
      @booked_rooms << @free_rooms.pop
    end

    def add_reservation(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Can only add reservation instance to reservations collection")
      end
      book_room(reservation)
      @reservations << reservation
    end

    def reservations_for_day(date)
      date = validate_date(date)

      day_list = @reservations.select { |reservation| reservation.dates.include? date }
    end

    def free_rooms_for_day(date)
      date = validate_date(date)
      reservations_for_day(date)
      @free_rooms
    end

    def validate_date(date)
      if date == nil || date.class != String
        raise ArgumentError.new("date is invalid")
      else
        date = Date.parse(date)
      end
    end

  end

end
