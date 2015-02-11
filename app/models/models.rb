module Models
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    #Creates a new object from a single row
    def import_row(row)
      self.new(row)
    end
  end
end