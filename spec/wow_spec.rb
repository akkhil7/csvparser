require_relative '../wow.rb'
DELIMITERS = [',', ';', '\t']

describe CSVParser do

  before :each do
    @parse = CSVParser.new File.join File.dirname(__FILE__), 'data.csv'
  end

  describe "#new" do
    it "returns a csvparser object" do
      expect(@parse).to be_an_instance_of CSVParser
    end

    it "throws an error when given no file path" do
      expect(lambda { CSVParser.new }).to raise_exception ArgumentError
    end
  end

  describe "#filepath" do
    it "returns a valid file" do
      file = File.exist?(@parse.filepath)
      expect(file).to eq true
    end
  end

  describe "#guess_delimiter" do
    it "returns a valid delimiter" do
      delimiter = @parse.send(:guess_delimiter)
      expect(delimiter).not_to eq nil
    end
  end

  describe "#occurence" do
    it "returns a count" do
      count = @parse.send(:occurence, DELIMITERS.sample)
      expect(count).to be_a_kind_of Integer
    end
  end

  describe "#csv_string" do
    it "returns a string" do
      csvstring = @parse.send(:csv_string)
      expect(csvstring).to be_a_kind_of String
    end
  end

  describe "#clean" do
    it "string has no empty lines" do
      csvstring = @parse.send(:csv_string)
      result = @parse.send(:clean, csvstring)
      is_clean = result.match(/\r\n/) ? true : false
      expect(is_clean).to be_falsy
    end
  end

  describe "#parsed_csv" do
    it "returns an array of all rows in csv" do
      result_count = @parse.send(:parsed_csv).length
      csvstring = @parse.send(:csv_string)
      string_line_count = @parse.send(:clean, csvstring).count("\n")
      expect(result_count).to eq string_line_count
    end

    it "returns an array with all elements of string " do
      result = @parse.send(:parsed_csv)
      expect(result).to all be_a(String)
    end
  end

end

describe Row do

  before :each do
    @row = Row.new("akhil","akhilr@gmail.com","9099099099")
  end

  describe "#new" do
    it "returns a row object" do
      expect(@row).to be_an_instance_of Row
    end
  end

end
