# frozen_string_literal: true

require_relative '../formatters/time_formatter'

class TimeApp
  def initialize(_app); end

  def call(env)
    request = Rack::Request.new(env)

    if request_valid?(request)
      handle(request)
    else
      response("Page not found\n", 404, headers)
    end
  end

  private

  def handle(request)
    formats = request.params['format']

    if formats.nil?
      response("Format not found\n", 400, headers)
    else
      formatter = TimeFormatter.new(Time.now, formats)
      @formatted = formatter.format
      @unknown_formats = formatter.unknown_formats
      response(body, status, headers)
    end
  end

  def response(body, status, headers)
    Rack::Response.new(body, status, headers).finish
  end

  def status
    @unknown_formats.any? ? 400 : 200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    @unknown_formats.any? ? "Unknown time format #{@unknown_formats}\n" : @formatted
  end

  def request_valid?(request)
    request.path == '/time'
  end
end
