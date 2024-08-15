# Log Parser

## Overview

This application is designed to parse server log files and generate HTML reports based on the parsed data. It uses the `LogParser` class to handle the parsing of log files and generates reports using ERB templates.

## Features

- Parses log files to extract relevant information.
- Generates HTML reports from the parsed log data.
- Handles invalid file paths gracefully.

## Requirements

- Ruby (version 2.5 or higher)
- Bundler (for managing dependencies only if you want to run tests and linting)

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/HussainNiazi120/log_parser.git
    cd log_parser
    ```
2. Install the dependencies if you want to run tests and rubocop for linting:
    ```sh
    bundle install
    ```

## Usage

To run the log parser, use the following command:
    ```sh
    ruby parse.rb <file_path>
    ```

## Example
To run the log parser on file name webserver.log
    ```sh
    ruby parse.rb webserver.log
    ```

This will generate an HTML report and print a success message with the path to the generated report.

https://github.com/user-attachments/assets/36175022-6992-484f-9e02-0ef9d522ea4c

## Testing

To run the tests, use the following command:
    ```sh
    rspec
    ```
