# frozen_string_literal: true

require 'rspec'
require_relative '../../classes/log_parser'

# rubocop:disable Metrics/BlockLength
RSpec.describe LogParser do
  let(:valid_file_path) { 'spec/fixtures/valid_log_file.log' }
  let(:invalid_file_path) { 'invalid/path/to/log_file.log' }
  let(:sample_report_path) { 'spec/fixtures/sample_report.html' }

  describe '#initialize' do
    it 'raises an error when initialized with no file_path' do
      expect { LogParser.new }.to raise_error(ArgumentError)
    end

    it 'raises an error when initialized with an invalid file path' do
      expect { LogParser.new(invalid_file_path) }.to raise_error(LogParser::InvalidPathError)
    end

    it 'successfully initializes with a valid file path' do
      expect { LogParser.new(valid_file_path) }.not_to raise_error
    end
  end

  describe '#parse' do
    it 'parses the log data into entries' do
      parser = LogParser.new(valid_file_path)
      parser.parse
      expect(parser.entries).not_to be_empty
      expect(parser.entries['/page_1'][:hits]).to eq(3)
      expect(parser.entries['/page_2'][:hits]).to eq(3)
      expect(parser.entries['/page_3'][:hits]).to eq(1)
      expect(parser.entries['/page_4#anchor'][:hits]).to eq(1)
      expect(parser.entries['/a/page_3?query=test&sort=desc'][:hits]).to eq(1)

      expect(parser.entries['/page_1'][:ip_addresses]).to eq(['192.168.0.1'])
      expect(parser.entries['/page_2'][:ip_addresses]).to eq(['192.168.0.1', '192.168.0.2', '192.168.100.254'])
      expect(parser.entries['/page_3'][:ip_addresses]).to eq(['192.168.0.2'])
      expect(parser.entries['/page_4#anchor'][:ip_addresses]).to eq(['192.168.100.254'])
      expect(parser.entries['/a/page_3?query=test&sort=desc'][:ip_addresses]).to eq(['192.168.0.1'])
    end
  end

  describe '#sort_by_most_views_and_unique_views' do
    it 'sorts entries by most views' do
      parser = LogParser.new(valid_file_path)
      parser.parse
      sorted_entries = parser.most_views
      expect(sorted_entries[0][0]).to eq('/page_1')
      expect(sorted_entries[1][0]).to eq('/page_2')
      expect(sorted_entries[2][0]).to eq('/a/page_3?query=test&sort=desc')
      expect(sorted_entries[3][0]).to eq('/page_3')
      expect(sorted_entries[4][0]).to eq('/page_4#anchor')
    end

    it 'sorts entries by unique views' do
      parser = LogParser.new(valid_file_path)
      parser.parse
      sorted_entries = parser.unique_views
      expect(sorted_entries[0][0]).to eq('/page_2')
      expect(sorted_entries[1][0]).to eq('/page_1')
      expect(sorted_entries[2][0]).to eq('/a/page_3?query=test&sort=desc')
      expect(sorted_entries[3][0]).to eq('/page_3')
      expect(sorted_entries[4][0]).to eq('/page_4#anchor')
    end
  end

  describe '#validate_log_entry' do
    it 'prints a message to the console if an invalid log entry is found' do
      parser = LogParser.new('spec/fixtures/invalid_log_file.log')
      expect { parser.parse }.to output("Invalid log entry: Hello World!\n" \
                                        "Invalid log entry: \n" \
                                        "Invalid log entry: Good Bye!\n").to_stdout
    end
  end
end
# rubocop:enable Metrics/BlockLength
