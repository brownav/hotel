require_relative 'spec_helper'

describe "Reservation class" do

  describe "Initializer" do

    ### raises error if end_date is before start_date
    it "is an instance of Reservation" do
      reservation = Hotel::Reservation.new(['6th March 2017', '7th March 2017'])

      reservation.must_be_kind_of Hotel::Reservation
    end

    it "input is an array of strings" do
      input = ['6th March 2018', '7th March 2018']

      reservation = Hotel::Reservation.new(input)

      input.must_be_kind_of Array
      input.first.must_be_kind_of String
    end

    it "raises an error for nil or invalid input" do
      proc {Hotel::Reservation.new("")}.must_raise ArgumentError
    end

    it "stores input as an instance of date" do
      reservation = Hotel::Reservation.new(['6th March 2017', '7th March 2017'])

      first_day = reservation.dates.first
      last_day = reservation.dates.last

      first_day.must_be_kind_of Date
      last_day.must_be_kind_of Date
    end

    it "is set up for specific attributes and data types" do
      reservation = Hotel::Reservation.new(['6th March 2017', '7th March 2017'])

      reservation.must_respond_to :dates
      reservation.dates.must_be_kind_of Array
    end

    describe "cost method" do
      before do
        @reservation = Hotel::Reservation.new(['6th March 2017', '7th March 2017'])
      end

      it "charge at least 200" do
        @reservation.cost.must_be :>=, 200
      end

      it "returns total cost per reservation" do
        total_nights = @reservation.dates.length
        expectation = total_nights * 200

        @reservation.cost.must_equal expectation
      end
    end
  end
end
