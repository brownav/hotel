require_relative 'reservation'
require 'date'
require 'pry'

module Hotel
  # access list of reservations for specific date
  # access list of all rooms in hotel

  class Admin
    attr_reader :rooms, :reservations

    def initialize
      @reservations = []
      @rooms = rooms_list
    end

    def rooms_list
      rooms = []
      (1..20).each { |i| rooms << i }
      return rooms
    end

    # takes in an instance of reservation
    def book_room(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Can only use reservation instance to book a room")
      end

      @rooms.pop
      return @rooms
    end

    # takes in an instance of reservation
    def add_reservation(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Can only add reservation instance to reservations collection")
      end

      @reservations << reservation
    end

    def reservations_for_day(date)
      date = validate_date(date)

      day_list = []
      @reservations.each do |reservation|
        reservation.dates.each do |day|
          if day == date
            day_list << day
          end
        end
      end
      return day_list
      binding.pry
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
