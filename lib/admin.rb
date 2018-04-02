require_relative 'reservation'
require_relative 'block'
require 'date'
require 'pry'

module Hotel
  class Admin
    attr_reader :rooms, :reservations, :blocks

    def initialize
      @reservations = []
      @rooms = (1..20).to_a
      @blocks = []
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

    def reserve_block(dates, num_rooms)
      dates = validate_dates(dates)

      if num_rooms.class != Integer || num_rooms < 1 || num_rooms > 5
        raise ArgumentError.new("Number of rooms is invalid #{num_rooms}")
      elsif free_rooms_for_dates(dates).length < num_rooms
        raise ArgumentError.new("Not enough free rooms for these dates #{dates}")
      end

      id = @blocks.length + 1
      open_rooms = free_rooms_for_dates(dates).pop(num_rooms)
      booked_rooms = []
      block = Block.new(id: id, dates: dates, open_rooms: open_rooms, booked_rooms: booked_rooms)

      @blocks << block
      @reservations << dates

      return block
    end

    def book_room_in_block(block_id)
      if block_id.class != Integer || block_id > @blocks.length || block_id < @blocks.length || block_id == nil
        raise ArgumentError.new("Invalid block id #{block_id}")
      end

      block = @blocks[block_id - 1]
      block.book_room
    end

    def block_open_rooms(block_id)
      block = @blocks[block_id - 1]
      block.open_rooms
    end

    def reservations_on_day(day)
      day = validate_dates(day)

      reserved_list = @reservations.select { |reservation| reservation.dates.include? day }

      return reserved_list
    end

    def free_rooms_for_dates(days)
      days = validate_dates(days)

      @rooms = (1..20).to_a
      @blocks = []

      @reservations.each do |reservation|
        overlap = reservation.dates & days
        if overlap.length > 0
          @rooms.pop
        end
      end

      return @rooms
    end

    def validate_dates(dates)
      if dates == nil
        raise ArgumentError.new("Date is invalid #{dates}")
      elsif dates.class == String
        Date.parse(dates)
      elsif dates.class == Reservation || dates[0].class == Date
        return dates
      elsif dates[0].class != String
        raise ArgumentError.new("Date is invalid #{dates}")
      else
        dates.map { |date| date = Date.parse(date) }
      end
    end

  end
end
