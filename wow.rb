require 'csv'
require 'active_model'

class Row
  include ActiveModel::Validations

  attr_accessor :name, :email, :number

# Using ActiveModel Validations to validate the columns
  validates :name, presence: true
  validates :number, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def initialize(name, email, number)
    @name = name
    @email = email
    @number = number
  end
end

class CSVParser
  DELIMITERS = [',', ';', '\t']

  attr_accessor :valid_rows, :invalid_rows, :filepath

  def initialize(filepath)
    @filepath = filepath
    @valid_rows = []
    @invalid_rows = []
  end

  def start
    validate
  end

  private

# Guessing the delimiter by counting the most occuring delimiter
  def guess_delimiter
    DELIMITERS.max do |delimiter|
      occurence(delimiter)
    end
  end

  def occurence(delimiter)
    csv_string.count(delimiter)
  end

# Reads the CSV file
  def csv_string
    File.read(@filepath)
  end

# Cleans the csv string of any empty lines
  def clean(csv_string)
    csv_string.squeeze('\r\n')
  end

# Parsing the CSV file to an array of rows
  def parsed_csv
    CSV.parse(clean(csv_string), col_sep: guess_delimiter).flatten
  end

# Gets the rows
  def rows
    parsed_csv.map { |row| row.split(',') }
  end

# Gets only the body leaving out the header row
  def body
    rows.drop(1)
  end

# Validate each row one by one
  def validate
    body.each do |row|
      new_row = Row.new(*row)
      if new_row.valid?
        valid_rows.push(new_row)
      else
        invalid_rows.push error: new_row
      end
    end
    generate_result
  end

# Generate the result
  def generate_result
    { invalid: invalid_rows, valid: valid_rows }
  end
end


csvparser = CSVParser.new(File.join(File.dirname(__FILE__), 'data.csv'))
csvparser.start

print csvparser.invalid_rows
2.times { puts }
print csvparser.valid_rows
