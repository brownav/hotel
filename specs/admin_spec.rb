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
      admin.rooms.must_be_kind_of Array
      admin.rooms.length.must_equal 20

      admin.must_respond_to :reservations
      admin.reservations.must_be_kind_of Array
    end
  end

  describe "book_room method" do
    it "raises error if input is not instance of reservation" do
      admin = Hotel::Admin.new
      reservation = Hotel::Reservation.new(['12 May 2018', '13 May 2018'])

      proc {admin.book_room("")}.must_raise ArgumentError
      proc {admin.book_room('12 May 2017')}.must_raise ArgumentError
    end

    it "removes a room from rooms list" do
      admin = Hotel::Admin.new
      reservation = Hotel::Reservation.new(['12 May 2018', '13 May 2018'])
      initial_rooms = admin.rooms.length

      admin.book_room(reservation)

      admin.rooms.length.must_equal initial_rooms - 1
    end
  end

  describe "reservations_for_day method" do

    it "must raise error if input is invalid" do
      admin = Hotel::Admin.new

      proc {admin.reservations_for_day("")}.must_raise ArgumentError
      proc {admin.reservations_for_day(12)}.must_raise ArgumentError
    end

    it "must return a list of reservations" do
      admin = Hotel::Admin.new

      day_list = admin.reservations_for_day('12 May 2018')

      day_list.must_be_kind_of Array
      day_list.length.must_be :>, 0
    end

    it "must return reservations for a correct day" do
      admin = Hotel::Admin.new

      first_reservation = admin.reservations_for_day('12 May 2018').first
      date = Date.parse('12 May 2018')

      first_reservation.must_include date
    end

  end
end
