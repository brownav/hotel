require_relative 'spec_helper'

describe "Admin class" do
  describe "Initializer" do
    it "is an instance of Admin" do
      admin = Hotel::Admin.new

      admin.must_be_kind_of Hotel::Admin
    end

    it "is set up for specific attributes and data types" do
      admin = Hotel::Admin.new

      admin.must_respond_to :rooms
      admin.rooms.length.must_equal 20
      admin.must_respond_to :reservations
      admin.reservations.must_be_kind_of Array
    end
  end

  describe "book_room method" do
    it "raises error if input is not instance of reservation" do
      admin = Hotel::Admin.new
      reservation = Hotel::Reservation.new(['12 May', '13 May'])

      proc {admin.book_room("")}.must_raise ArgumentError
      proc {admin.book_room('12 May 2017')}.must_raise ArgumentError
    end

    it "removes a room from rooms list" do
      admin = Hotel::Admin.new
      res1 = Hotel::Reservation.new(['12 May', '13 May'])
      free_rooms = admin.rooms.length

      admin.book_room(res1)

      admin.rooms.length.must_equal free_rooms - 1
    end
  end

  describe "add_reservation method" do
    it "must raise error if input is not an instance of reservation" do
      admin = Hotel::Admin.new

      proc {admin.add_reservation(" ")}.must_raise ArgumentError
      proc {admin.add_reservation('reservation')}.must_raise ArgumentError
    end

    it "raises error if there are no free rooms for those reservation dates" do
      admin = Hotel::Admin.new

      20.times do
        admin.add_reservation(Hotel::Reservation.new(["5 March"]))
      end

      proc {admin.add_reservation(Hotel::Reservation.new(["5 March"]))}.must_raise ArgumentError
    end

    it "must add reservations to reservations collection" do
      admin = Hotel::Admin.new
      reservation = Hotel::Reservation.new(['12 May', '13 May','14 May'])
      initial = admin.reservations.length

      admin.add_reservation(reservation)

      admin.reservations.length.must_equal initial + 1
    end
  end

  describe "reservations_on_day method" do
    it "must raise error if dates are invalid" do
      admin = Hotel::Admin.new

      proc {admin.reservations_on_day("")}.must_raise ArgumentError
      proc {admin.reservations_on_day(12)}.must_raise ArgumentError
    end

    it "must return a list of reservations" do
      admin = Hotel::Admin.new
      res1 = Hotel::Reservation.new(['12 May', '13 May'])
      res2 = Hotel::Reservation.new(['12 May'])
      res3 = Hotel::Reservation.new(['15 March'])
      admin.add_reservation(res1)
      admin.add_reservation(res2)
      admin.add_reservation(res3)

      list_one = admin.reservations_on_day('12 May')
      list_two = admin.reservations_on_day('13 May')
      list_three = admin.reservations_on_day('15 March')

      list_one.must_be_kind_of Array
      list_one.length.must_equal 2
      list_two.length.must_equal 1
      list_three.length.must_equal 1
    end

    it "must return reservations for correct day" do
      admin = Hotel::Admin.new
      res1 = Hotel::Reservation.new(['12 May', '13 May'])
      res2 = Hotel::Reservation.new(['12 May'])
      res3 = Hotel::Reservation.new(['15 March'])
      admin.add_reservation(res1)
      admin.add_reservation(res2)
      admin.add_reservation(res3)

      admin.reservations_on_day('12 May').each do |res|
        res.dates.must_include Date.parse('12 May')
      end

      admin.reservations_on_day('15 March').each do |res|
        res.dates.must_include Date.parse('15 March')
      end
    end
  end

  describe "free_rooms_for_dates method" do
    it "raises an error if dates are invalid" do
      admin = Hotel::Admin.new

      proc {admin.reservations_on_day(['abcdefg'])}.must_raise ArgumentError
      proc {admin.reservations_on_day([23])}.must_raise ArgumentError
      proc {admin.reservations_on_day([nil])}.must_raise ArgumentError
      proc {admin.reservations_on_day([""])}.must_raise ArgumentError
    end

    it "returns collection of available rooms for given dates" do
      admin = Hotel::Admin.new
      res1 = Hotel::Reservation.new(['12 May'])
      res2 = Hotel::Reservation.new(['12 May', '13 May'])
      res3 = Hotel::Reservation.new(['15 March'])
      admin.add_reservation(res1)
      admin.add_reservation(res2)
      admin.add_reservation(res3)

      admin.free_rooms_for_dates(['20 May']).must_be_kind_of Array
      admin.free_rooms_for_dates(['20 May']).length.must_equal 20
      admin.free_rooms_for_dates(['15 March']).length.must_equal 19
      admin.free_rooms_for_dates(['12 May']).length.must_equal 18
      admin.free_rooms_for_dates(['12 May', '13 May', '15 March']).length.must_equal 17
    end
  end

  describe "create_block_of_rooms method" do
    it "is set up for specific data types and attributes" do
      admin = Hotel::Admin.new
      res = Hotel::Reservation.new(['12 May', '13 May', '14 May'])

      block = admin.create_block_of_rooms(res, 3)

      block.must_be_kind_of Array
      block.first.must_be_kind_of Hash
      admin.must_respond_to :blocks
    end

    it "accurately books a block of free rooms" do
      admin = Hotel::Admin.new
      res = Hotel::Reservation.new(['12 May', '13 May', '14 May'])

      free_rooms = admin.rooms.length
      block = admin.create_block_of_rooms(res, 3)
      blocked_rooms = block.first[:available_rooms].length
      remaining_rooms = admin.rooms.length

      block.first.keys.must_equal [:id, :dates, :available_rooms, :booked_rooms]
      block.first[:id].must_be_kind_of Integer
      block.first[:dates].must_equal res.dates
      blocked_rooms.must_equal 3
      block.first[:booked_rooms].length.must_equal 0
      (free_rooms - blocked_rooms).must_equal remaining_rooms
    end

    it "raises an error for invalid number of rooms input" do
      # reservations/dates already validated via helper method
      admin = Hotel::Admin.new
      res = Hotel::Reservation.new(['12 May', '13 May', '14 May'])

      string = "flower"
      less_than_one = 0
      more_than_five = 6

      proc {admin.create_block_of_rooms(res, string)}.must_raise ArgumentError
      proc {admin.create_block_of_rooms(res, less_than_one)}.must_raise ArgumentError
      proc {admin.create_block_of_rooms(res, more_than_five)}.must_raise
      ArgumentError
    end
  end

  describe "book_room_in_block method" do
    it "raises an error for an invalid block id" do
      admin = Hotel::Admin.new

      string = "string"
      negative = -1
      too_high = 10
      empty = nil

      proc {admin.book_room_in_block(string)}.must_raise ArgumentError
      proc {admin.book_room_in_block(negative)}.must_raise ArgumentError
      proc {admin.book_room_in_block(too_high)}.must_raise ArgumentError
      proc {admin.book_room_in_block(empty)}.must_raise ArgumentError
    end

    it "books an available room from a given block" do
      admin = Hotel::Admin.new
      res = Hotel::Reservation.new(["12 May", "13 May", "14 May"])
      block_array = admin.create_block_of_rooms(res, 5)
      block = block_array[0]

      open_rooms = block[:available_rooms].length
      admin.book_room_in_block(1)

      open_rooms.must_equal open_rooms - 1
      block[:booked_rooms].length.must_equal 1
    end

  end

end
