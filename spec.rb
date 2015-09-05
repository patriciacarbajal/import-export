require_relative 'csv_parser'

describe CSVParser do
  let(:parser_json) { CSVParser.new('example.csv', 'new_json_file.json', 'json') }
  let(:parser_yaml) { CSVParser.new('example.csv', 'new_yaml_file.yaml', 'yaml') }


  describe '#initialize' do
    it 'should parse the CSV file and extract the item description into an array - JSON' do
      expect(parser_json.csv_array_json[0][1]).to eq 'Coffee'
    end

    it 'should parse the CSV file and extract the item description into an array - YAML' do
      expect(parser_json.csv_array_yaml[1][1]).to eq 'Coffee'
    end

    it 'should parse the CSV file and return an row for each cvs line except for the header - for JSON' do
      expect(parser_json.csv_array_json.length).to eq 14
    end

    it 'should parse the CSV file and return an array for each row - for YAML' do
      expect(parser_yaml.csv_array_yaml.length == 15 && parser_yaml.csv_array_yaml.all?{ |x| x.kind_of?(Array)}).to be true
    end
  end

  describe '#save' do
    it 'should create a new json file for writing if json type is chosen' do
      parser_json.save
      directory_files = %x{ ls }
      expect(directory_files.split("\n").include?("new_json_file.json")).to be true
    end

    it 'should create a new yaml file for writing if yaml type is chosen' do
      parser_yaml.save
      directory_files = %x{ ls }
      expect(directory_files.split("\n").include?("new_yaml_file.yaml")).to be true
    end
  end
end