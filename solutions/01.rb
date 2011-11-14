class Array
  def to_hash
    Hash[*self.flatten(1)]
  end

  def index_by
    h=Hash.new
    map { |x| h[yield x] = x }
    h
  end

  def subarray_count(array)
    each_cons(array.length).count(array)
  end

  
  def occurences_count
    h = Hash.new(0)
    self.each{ |x| h[x] = self.count(x) }
    h
  end

end