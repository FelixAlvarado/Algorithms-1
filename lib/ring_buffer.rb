require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @length = 0 
    @capacity = 8
    @start_idx = 0
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if @length == 0 || index >= @length
    @store[(@start_idx + index) % @capacity]
  end

  # O(1)
  def []=(index, val)
    raise "index out of bounds" if index >= @length
    @store[(@start_idx + index) % @capacity] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length == 0
    last_index = (@start_idx + @length - 1) % @capacity
    result = @store[last_index]
    @store[last_index] = nil
    @length -= 1
    result
  end

  # O(1) ammortized
  def push(val)
    resize! if @length >= @capacity
    if @length < @capacity
      i = @start_idx
      until @store[i] === nil
        i += 1
        i -= @capacity if i >= @capacity
      end 
      @store[i] = val
      @length += 1
    else 
      resize!
      i = @start_idx
      until @store[i] = nil 
        i += 1
      end 
      @store[i] = val
      @length += 1
    end 
  end

  # O(1)
  def shift
    raise "index out of bounds" if @length == 0
    result = @store[@start_idx]
    @length -= 1
    @store[@start_idx] = nil
    @start_idx += 1
    @start_idx -= @capacity if @start_idx >= @length
    result
  end

  # O(1) ammortized
  def unshift(val)
      resize! if @length >= @capacity
      i = @start_idx
      until @store[i] == nil
        i-=1
        i += @capacity if i < 0
      end 
      @start_idx = i
      @store[i] = val
      @length += 1
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  def resize!
    old_array = @store
    new_array = StaticArray.new(@capacity * 2)
    @length.times do |i|
      test_index = @start_idx + i
      new_array[test_index % (@capacity*2)] = old_array[test_index % @capacity]
    end 
    # (@capacity/2..@capacity - 1).each do |i|
    #   @store[i + @capacity/2] = @store[i]
    #   @store[i] = nil
    # end 
    @capacity *= 2
    @store = new_array
  end
end
