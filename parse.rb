# frozen_string_literal: true

# This script is responsible for parsing log files and generating reports.
# It uses the LogParser class to parse the log file and generates an HTML report.
# The script expects the file path to be provided as a command-line argument.
#
# Usage:
#   ruby parse.rb <file_path>
#
# Example:
#   ruby parse.rb webserver.log
#
# The script performs the following steps:
# 1. Retrieves the file path from the command-line arguments.
# 2. Generates the report path based on the provided file path.
# 3. Parses the log file using the LogParser class.
# 4. Generates the report and saves it to the specified report path.
# 5. Prints a success message with the report path if the report is generated successfully.
# 6. Handles errors that occur during the log parsing and report generation process.
#
# The script defines the following methods:
# - main: The entry point of the script.
# - file_path_from_argv: Retrieves the file path from the command-line arguments.
# - generate_report_path: Generates the report path based on the provided file path.
# - generate_report: Generates the report based on the parsed log data and saves it to the specified report path.
# - handle_error: Handles errors that occur during the log parsing and report generation process.

require_relative 'classes/log_parser'
require 'erb'

def main
  file_path = file_path_from_argv
  report_path = generate_report_path(file_path)

  begin
    log = LogParser.new(file_path)
    log.parse
    generate_report(log, report_path)
    puts "Report generated successfully. Please open #{File.expand_path(report_path)} to view it."
  rescue LogParser::InvalidPathError => e
    handle_error(e)
  end
end

def file_path_from_argv
  file_path = ARGV[0]
  unless file_path
    puts 'Please provide the file path'
    exit
  end
  file_path
end

def generate_report_path(file_path)
  "reports/#{File.basename(file_path, '.*')}.html"
end

def handle_error(error)
  puts error.message
  exit
end

def generate_report(log, report_path)
  @most_views_table = generate_table('mostViewsContainer', 'mostViewsTable', log.most_views, 'display: block')
  @unique_views_table = generate_table('uniqueViewsContainer', 'uniqueViewsTable', log.unique_views, 'display: none')

  template = ERB.new(File.read('templates/report_template.html.erb'))
  File.write(report_path, template.result(binding))
end

def generate_table(table_id, report_table_id, data, display_style)
  @table_id = table_id
  @report_table_id = report_table_id
  @data = data
  @display_style = display_style
  ERB.new(File.read('templates/table_template.html.erb')).result(binding)
end

main if __FILE__ == $PROGRAM_NAME
