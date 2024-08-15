# frozen_string_literal: true

# The LogParser class is responsible for parsing web server log files.
# It processes each line of the log file, extracts the path and IP address,
# and maintains a record of the number of hits and unique IP addresses for each path.
#
# Example usage:
#   parser = LogParser.new('path/to/logfile.log')
#   parser.parse
#   puts parser.most_views
#   puts parser.unique_views
#
# Public Methods:
# - initialize(file_path, display_progress: true, progress_interval: 10): Initializes the LogParser
#   with the given file path.
# - parse: Parses the log file and processes each line.
# - most_views: Returns the paths sorted by the number of hits in descending order.
# - unique_views: Returns the paths sorted by the number of unique IP addresses in descending order.
#
# Private Methods:
# - validate_file_path: Validates the file path.
# - process_line(line): Processes a single line of the log file.
# - valid_entry?(line): Checks if a log entry is valid.
# - print_progress(i): Prints the progress of the parsing.
class LogParser
  class InvalidPathError < StandardError; end

  attr_reader :entries

  def initialize(file_path, display_progress: true, progress_interval: 10)
    @file_path = file_path
    validate_file_path
    @entries = Hash.new { |hash, key| hash[key] = { hits: 0, ip_addresses: [] } }
    @display_progress = display_progress
    @progress_interval = progress_interval
  end

  def parse
    File.open(@file_path, 'r') do |file|
      file.each_line.with_index(1) do |line, i|
        process_line(line)
        print_progress(i) if @display_progress && (i % @progress_interval).zero?
      end
    end
  end

  def most_views
    @entries.sort_by { |_, data| -data[:hits] }
  end

  def unique_views
    @entries.sort_by { |_, data| -data[:ip_addresses].count }
  end

  private

  def validate_file_path
    return if File.exist?(@file_path)

    raise InvalidPathError, "The file path #{@file_path} is invalid."
  end

  def process_line(line)
    if valid_entry?(line)
      path, ip = line.split
      @entries[path] ||= { hits: 0, ip_addresses: [] }
      @entries[path][:hits] += 1
      @entries[path][:ip_addresses] << ip unless @entries[path][:ip_addresses].include?(ip)
    else
      puts "Invalid log entry: #{line}"
    end
  end

  def valid_entry?(line)
    # This regex matches a string that starts with a /, followed by
    #  one or more non-whitespace characters (the path), a space, and an IP address
    #  in the format xxx.xxx.xxx.xxx, where each xxx is a 1 to 3 digit number.
    line.match?(%r{^/\S+\s\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$})
  end

  def print_progress(index)
    print "Total lines processed: #{index} -- Total paths found: #{@entries.keys.count}\r"
  end
end
