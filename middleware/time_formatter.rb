# frozen_string_literal: true

class TimeFormatter
  def initialize(_app); end

  def call(env)
    @env = env

    set_time
    available_formats
    requested_formats

    [status, headers, body]
  end

  private

  def status
    return 404 if @env['REQUEST_PATH'] != '/time'
    return 400 if formats_invalid?

    200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    return ["Page not found\n"] if status == 404
    return ["Format not found\n"] if @formats.nil?
    return ["Unknown time format #{unknown_formats}\n"] if unknown_formats.any?

    [format]
  end

  def set_time
    @current_time = Time.now
  end

  def available_formats
    @available_formats = {
      year: @current_time.year,
      month: @current_time.month,
      day: @current_time.day,
      hour: @current_time.hour,
      minute: @current_time.min,
      second: @current_time.sec
    }
  end

  def requested_formats
    @formats = Rack::Utils.parse_nested_query(@env['QUERY_STRING'])['format']&.split(',')
  end

  def formats_invalid?
    @formats.nil? || unknown_formats.any?
  end

  def unknown_formats
    @formats.each_with_object([]) do |format, unknown_formats|
      unknown_formats << format if @available_formats[format.to_sym].nil?
    end
  end

  def format
    @formats.map { |part| @available_formats[part.to_sym].to_s.rjust(2, '0') }
            .join('-')
  end
end
