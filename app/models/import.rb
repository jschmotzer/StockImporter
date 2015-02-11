require 'csv'

class Import < ActiveRecord::Base
  include Models

  VALID_FILE_TYPES = ['text/csv']

  #Handles the file import based on format type
  def handle_import_file(klass, file)
    case file.content_type
    when 'text/csv'
      handle_csv(klass, file)
    end 
  end

  #Processes the csv. Creates a new record for each row and returns JSON for imported file.
  def handle_csv(klass, file)
    imported_rows = import_csv(file)
    imported_rows = imported_rows.map do |row|
      #transform row to fit klass for saving
      transformed_modifiers = transform_modifiers(row)
      transformed_row = transform_row(row, transformed_modifiers, klass)
      new_object = klass.constantize.import_row(transformed_row)
      new_object.save
      transformed_row
    end
  end

  #Reads CSV file with headers
  def import_csv(file)
    rows = []
    CSV.foreach(file.path, headers: true) do |row|
      rows << row.to_hash
    end
    rows
  end

  #Maps the CSV file headers to the column name used on each model.
  def transform_row(row, transformed_modifiers, klass)
    row['modifiers'] = transformed_modifiers
    row.reject! { |k,v| /modifier_\d/.match(k) }
    mapped_column_names = Hash[row.map { |k,v| [klass.constantize.map_columns[k], v] }]
  end

  #Finds all modifiers in a csv row and returns an array of objects.
  def transform_modifiers(row)
    modifiers = []
    #grab pairs of modifiers - name, price
    #Could have used each_slice(2), but was uncertain of the number of modifiers.
    matched_modifiers = row.select {|k,v| /modifier_\d/.match(k)}
    # matched_modifiers
    matched_length = matched_modifiers.length
    modifiers = []
    #Used the length of the modifiers to be certain objects were grouped correctly according to modifier number
    (1..matched_length).each do |num|
      results = matched_modifiers.select { |k, v| k =~ /modifier_#{num}/ }
      results.keys.each do |k|
        new_key_name = /(?<=modifier_#{num}_).+/.match(k)
        results[new_key_name.to_s] = results.delete(k)
      end
      modifiers << results
    end
    modifiers.reject! { |x| x.empty? }
    modifiers
  end

  def valid_file_type?(import_params)
    VALID_FILE_TYPES.include?(import_params[:file].content_type)
  end

end