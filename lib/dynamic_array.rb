require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @length = 0
    @store = StaticArray.new(0)
    @capacity = 8
  end

  # O(1)
  def [](index)
    raise "index out of bounds" if @length == 0 || index >= @length
    @store[index]
  end

  # O(1)
  def []=(index, value)
    raise "index out of bounds" if index >= @length
    @store[index] = value
  end

  # O(1)
  def pop
    raise "index out of bounds" if @length == 0
    @store[@length] = nil
    @length -= 1
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if @length < @capacity
      @store[@length] = val
      @length += 1
    else 
      @capacity *= 2
      (@capacity - 1).downto(@length - 1).each do |i|
        @store[i] = nil
      end 
      @store[@length] = val
      @length += 1
    end 
  end

  # O(n): has to shift over all the elements.
  def shift
    raise "index out of bounds" if @length == 0
    result = @store[0]
    @length -= 1
    (0..@length - 1).each do |i| 
      @store[i] = @store[i + 1]
    end 
    @store[length] = nil
    result
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    if @length < @capacity
      @length.downto(1) do |i|
        @store[i] = @store[i - 1]
      end 
      @store[0] = val
      @length += 1
    else 
      @capacity *= 2
      (@capacity - 1).downto(@length - 1).each do |i|
        @store[i] = nil
      end 
      @length.downto(1) do |i|
        @store[i] = @store[i - 1]
      end 
      @store[0] = val
    end 
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
  end
end
