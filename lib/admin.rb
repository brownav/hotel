require_relative 'reservation'
# require_relative 'room'
require 'date'
require 'pry'

module Hotel
  class Admin
    attr_reader :rooms, :reservations

    def initialize
      @reservations = []
      @rooms = room_list
    end

    def room_list
      rooms = []
      (1..20).each { |i| rooms << i }
      return rooms
    end

    def book_room(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Can only use reservation instance to book a room")
      end

      free_rooms_for_dates(reservation.dates).pop
    end

    def add_reservation(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Can only add reservation instance to reservations collection")
      end

      @reservations << reservation
      book_room(reservation)
    end

    def reservations_on_day(day)
      day = validate_dates(day)
      reserved_list = @reservations.select { |reservation| reservation.dates.include? day }
      return reserved_list
    end

    def free_rooms_for_dates(days)
      days = validate_dates(days)

      reserved_list = []
      @reservations.each do |reservation|
        match = reservation.dates & days
        if !(match.empty?)
          reserved_list << reservation
        end
      end

      @rooms.pop(reserved_list.length)

      return @rooms
    end

    def validate_dates(dates)
      if dates.class == Reservation || dates[0].class == Date
        return dates
      elsif dates == nil || dates[0].class != String
        raise ArgumentError.new("date is invalid")
      elsif dates.class == String
        Date.parse(dates)
      else
        dates.map { |date| date = Date.parse(date) }
      end
    end

  end

end
