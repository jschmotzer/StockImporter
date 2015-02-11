module Models
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    #Imports a single row
    #param [Hash] row
    #return [Object] imported object
    def import_row(row)
      self.new(row)
    end
  end
end