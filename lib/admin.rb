require_relative 'reservation'
require 'date'
require 'pry'

module Hotel
  class Admin
    attr_reader :rooms, :reservations, :blocks

    def initialize
      @reservations = []
      @rooms = room_list
      @blocks = []
    end

    def room_list
      rooms = []
      (1..20).each { |i| rooms << i }
      return rooms
    end

    def book_room(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Can only use reservation instance to book a room #{reservation}")
      end

      free_rooms_for_dates(reservation.dates).pop
    end

    def add_reservation(reservation)
      if reservation.class != Reservation
        raise ArgumentError.new("Not a valid reservation instance #{reservation}")
      elsif free_rooms_for_dates(reservation.dates).length == 0
        raise ArgumentError.new("No available rooms for these dates #{reservation.dates}")
      end

      @reservations << reservation
      book_room(reservation)
    end

    def create_block_of_rooms(reservation, num_rooms)
      dates = validate_dates(reservation.dates)

      if num_rooms.class != Integer || num_rooms < 1 || num_rooms > 5
        raise ArgumentError.new("Number of rooms is invalid #{num_rooms}")
      end

      if free_rooms_for_dates(dates).length < num_rooms
        raise ArgumentError.new("Not enough free rooms for these dates #{dates}")
      end

      block = {}
      block[:id] = @blocks.length + 1
      block[:dates] = dates
      block[:available_rooms] = free_rooms_for_dates(dates).pop(num_rooms)
      block[:booked_rooms] = []
      @blocks << block

      return @blocks
    end

    def book_room_in_block(block_id)
      if block_id.class != Integer || block_id > @blocks.length || block_id < @blocks.length || block_id == nil
        raise ArgumentError.new("Invalid block id #{block_id}")
      end

      block = @blocks[block_id - 1]
      block[:booked_rooms] = block[:available_rooms].pop
    end

    # check whether given block has any rooms available
      # returns list of available rooms for particular block

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
        raise ArgumentError.new("Date is invalid #{dates}")
      else
        dates.map { |date| date = Date.parse(date) }
      end
    end

  end
end
