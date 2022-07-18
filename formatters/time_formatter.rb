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
    @unknown_formats = []
  end

  attr_reader :unknown_formats

  def format
    valid_formats = []

    @formats.split(',').each do |part|
      FORMATS[part.to_sym] ? valid_formats << FORMATS[part.to_sym] : unknown_formats << part
    end

    @time.strftime(valid_formats.join('-'))
  end
end
