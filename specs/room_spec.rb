require_relative 'spec_helper'

describe 'Room class' do
  describe 'Initializer' do
    it 'is an instance of room' do
      room = Hotel::Room.new(1)

      room.must_be_kind_of Hotel::Room
    end

    it 'has an id attribute' do
      room = Hotel::Room.new(1)

      room.must_respond_to :id
      room.id.must_be_kind_of Integer
    end

  end

end
