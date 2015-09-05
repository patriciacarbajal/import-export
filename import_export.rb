#!/usr/bin/env ruby
require_relative 'csv_parser'

#if user input not valid, display usage instructions. Else, convert file.
if ARGV.count < 3 || ARGV[0][-4, 4] != '.csv' || (ARGV[1][-5, 5] != '.json' && ARGV[1][-5, 5] != '.yaml') || (ARGV[2] != 'json' && ARGV[2] != 'yaml')
  puts "USAGE:  To convert CSV to JSON - './import_export.rb csv_file.csv export_filename.json json'"
  puts "        To convert CSV to YAML - './import_export.rb csv_file.csv export_filename.yaml yaml'"
else

  file = ARGV[0]
  export_file = ARGV[1]
  type = ARGV[2]

  parser = CSVParser.new(file, export_file, type)

  parser.save
end
