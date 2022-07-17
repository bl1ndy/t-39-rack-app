# frozen_string_literal: true

class TimeFormatter
  def initialize(app)
    @app = app
    @current_time = Time.now
    @formats = {
      year: @current_time.year,
      month: @current_time.month,
      day: @current_time.day,
      hour: @current_time.hour,
      minute: @current_time.min,
      second: @current_time.sec
    }
  end

  def call(env)
    status, headers, = @app.call(env)

    format = Rack::Utils.parse_nested_query(env['QUERY_STRING'])['format']
    body = [
      format.split(',')
            .map { |part| @formats[part.to_sym] }
            .join('-')
    ]

    [status, headers, body]
  end
end
