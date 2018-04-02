require_relative 'spec_helper'

describe "Block class" do
  before do
    @block = Hotel::Block.new(id: 1, dates: ["12 May", "13 May", "14 May"], open_rooms: [1, 2, 3], booked_rooms: [])

    describe "initializer" do
      it "is an instance of block" do
        @block.must_be_kind_of Hotel::Block
      end

      it "is set up for specific attributes and data types" do
        [:id, :dates, :open_rooms, :booked_rooms].each do |prop|
          @block.must_respond_to prop
        end

        @block.id.must_be_kind_of Integer
        @block.dates.must_be_kind_of Array
        @block.dates.first.must_be_kind_of String
        @block.open_rooms.must_be_kind_of Array
        @block.open_rooms.first.must_be_kind_of Integer
        @block.booked_rooms.must_be_kind_of Array
      end
    end

    describe "book_room method" do
      initial_open_rooms = @block.open_rooms

      @block.book_room

      @block.open_rooms.must_equal initial_open_rooms.first(2)
      @block.booked_rooms.must_equal initial_open_rooms.last
    end
  end
end
