require 'csv'

class Import < ActiveRecord::Base
  include Models

  VALID_FILE_TYPES = ['text/csv']

  #Handles the file import
  #param [String] klass
  #param [File] uploaded file
  def handle_import_file(klass, file)
    case file.content_type
    when 'text/csv'
      handle_csv(klass, file)
    end 
  end

  def handle_csv(klass, file)
    imported_rows = import_csv(file)
    imported_rows = imported_rows.map do |row|
      #transform row to fit klass for saving
      transformed_modifiers = transform_modifiers(row)
      transformed_row = transform_row(row, transformed_modifiers, klass)
      new_object = klass.constantize.import_row(transformed_row)
      new_object.save
      transformed_row
      #get new ids to create json
      # row_ids << new_object.id
    end
    # get_imported_file_json(klass, row_ids)
  end

  def import_csv(file)
    rows = []
    CSV.foreach(file.path, headers: true) do |row|
      rows << row.to_hash
    end
    rows
  end

  def transform_row(row, transformed_modifiers, klass)
    row['modifiers'] = transformed_modifiers
    row.reject! { |k,v| /modifier_\d/.match(k) }
    mapped_column_names = Hash[row.map { |k,v| [klass.constantize.import_columns[k], v] }]
  end

  def transform_modifiers(row)
    modifiers = []
    #grab pairs of modifiers - name, price
    #each_slice(2)
    matched_modifiers = row.select {|k,v| /modifier_\d/.match(k)}
    # matched_modifiers
    matched_length = matched_modifiers.length
    modifiers = []
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

  def get_imported_file_json(klass, row_ids)
    imported_json = klass.constantize.where(id: [row_ids]).to_json
  end

end