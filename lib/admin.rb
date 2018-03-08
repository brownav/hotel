require_relative 'reservation'
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
      elsif free_rooms_for_dates(reservation.dates).length == 0
        raise ArgumentError.new("No free rooms for these dates")
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
      @rooms = room_list

      @reservations.each do |reservation|
        overlap = reservation.dates & days
        if overlap.length > 0
          @rooms.pop
        end
      end

      return @rooms
    end

    def validate_dates(dates)
      if dates.class == String
        Date.parse(dates)
      elsif dates.class == Reservation || dates[0].class == Date
        return dates
      elsif dates == nil || dates[0].class != String
        raise ArgumentError.new("date is invalid")
      else
        dates.map { |date| date = Date.parse(date) }
      end
    end

  end

end
