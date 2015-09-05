require 'csv'
require 'json'
require 'yaml'

#remove dollar signs from the csv data
CSV::Converters[:remove_dollar_sign] = lambda do |field|
 field.match(/\$/) ? field.delete("$").to_f : field
end

class CSVParser
  attr_reader :type, :csv_array_json, :csv_array_yaml

  def initialize(file, export_file, type)
    @export_file = export_file
    @type = type
    @csv_array_json = CSV.read(file, headers: true, converters: [:all, :remove_dollar_sign])
    @csv_array_yaml = CSV.read(file, converters: [:all, :remove_dollar_sign])

  end

  def save 

   case @type

     when "json"
       File.open(@export_file, 'w') do |f|
        #the modifier keys from the csv will be deleted because we are creating a new "modifiers" array
        keys_to_delete = []
        f.puts JSON.pretty_generate(@csv_array_json.map do |row| 
          modifiers = []

          row.each do |key, value|
            #if the key matches the format "modifier_{number}_{type}"
            if key =~ /modifier_(\d)_(\w*)$/
              #check if the value is blank - if so, don't include it in the json file
              if value != nil
                #get the correct index for the modifier
                index = ($1).to_i - 1
                #enter the value in the corresponding hash if it exists, or create it if it doesnt
                modifiers[index] ||= {}
                modifiers[index][$2] = value
              end
            #once the data is taken from the key, add it to the keys_to_delete array
            keys_to_delete.push(key)
            end
            #create the modifiers section of the json object
            row['modifiers'] = modifiers
          end

          #delete each the keys we set to be deleted
          keys_to_delete.each { |key| row.delete(key) }

          #return the result as a hash to be written to the file as json
          row.to_hash
        end)
      end

     when "yaml"

     File.open(@export_file, "w") do |f| 
       #remove the first row of the csv and create an array of each header
       headers = @csv_array_yaml.shift.map {|header| header}

       #an array of hashes for each row in the csv
       #this process prevents unnecessary modifier fields from being printed 
       hash_array = @csv_array_yaml.map do |row|
         hash = {}
         #an array of each cell in the row
         cells_array = row.map {|cell| cell}
         cells_array.each_with_index do |value, index|
         #match value with appropriate header  
         hash[headers[index]] = value
         end
         hash
       end
       f.puts hash_array.to_yaml
     end
   end
  end

end