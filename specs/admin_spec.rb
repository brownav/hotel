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
      # admin.booked_rooms.length.must_equal 0
      # admin.booked_rooms.must_be_kind_of Array
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
    it "must raise error if input is invalid" do
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
    it "returns collection of available rooms for given dates" do
      admin = Hotel::Admin.new
      res1 = Hotel::Reservation.new(['12 May'])
      res2 = Hotel::Reservation.new(['12 May', '13 May'])
      res3 = Hotel::Reservation.new(['15 March'])
      admin.add_reservation(res1)
      admin.add_reservation(res2)
      admin.add_reservation(res3)

      admin.free_rooms_for_dates(['20 May']).must_be_kind_of Array

      admin.free_rooms_for_dates(['15 March']).length.must_equal 19
      admin.free_rooms_for_dates(['12 May']).length.must_equal 18
      admin.free_rooms_for_dates(['20 May']).length.must_equal 20
      admin.free_rooms_for_dates(['12 May', '13 May', '15 March']).length.must_equal 17
    end

  end

end
