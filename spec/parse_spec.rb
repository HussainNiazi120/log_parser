# frozen_string_literal: true

require 'rspec'
require_relative '../parse'
require_relative '../classes/log_parser'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'Parser' do
  let(:valid_file_path) { 'spec/fixtures/valid_log_file.log' }
  let(:invalid_file_path) { 'spec/fixtures/invalid_log_file.log' }
  let(:stubbed_report_path) { 'spec/test_report/valid_log_file.html' }
  let(:expected_report_path) { 'spec/sample_report/valid_log_file.html' }

  before do
    # Stub the generate_report_path method to return the stubbed path
    allow_any_instance_of(Object).to receive(:generate_report_path).and_return(stubbed_report_path)
  end

  context 'when no file path is provided' do
    it 'prints an error message and exits' do
      allow(ARGV).to receive(:[]).with(0).and_return(nil)
      expect { main }.to output("Please provide the file path\n").to_stdout.and raise_error(SystemExit)
    end
  end

  context 'when an invalid file path is provided' do
    it 'prints an error message and exits' do
      allow(ARGV).to receive(:[]).with(0).and_return(invalid_file_path)
      allow_any_instance_of(LogParser).to receive(:parse).and_raise(LogParser::InvalidPathError, 'Invalid file path')
      expect { main }.to output("Invalid file path\n").to_stdout.and raise_error(SystemExit)
    end
  end

  context 'when a valid file path is provided' do
    it 'generates the report successfully' do
      allow(ARGV).to receive(:[]).with(0).and_return(valid_file_path)
      expect do
        main
      end.to output('Report generated successfully. ' \
                    "Please open #{File.expand_path(stubbed_report_path)} to view it.\n").to_stdout

      generated_report = File.read(stubbed_report_path)
      expected_report = File.read(expected_report_path)
      expect(generated_report).to eq(expected_report)
    end
  end
end
# rubocop:enable Metrics/BlockLength
