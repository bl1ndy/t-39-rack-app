# frozen_string_literal: true

class TimeFormatter
  FORMATS = {
    year: '%Y',
    month: '%m',
    day: '%d',
    hour: '%H',
    minute: '%M',
    second: '%S'
  }.freeze

  def initialize(time, formats = '')
    @time = time
    @formats = formats || ''
    @valid_formats = []
    @unknown_formats = []
  end

  attr_reader :unknown_formats

  def call
    check_formats
    format
  end

  private

  def check_formats
    @formats.split(',').each do |format|
      FORMATS[format.to_sym] ? @valid_formats << FORMATS[format.to_sym] : @unknown_formats << format
    end
  end

  def format
    @time.strftime(@valid_formats.join('-'))
  end
end
