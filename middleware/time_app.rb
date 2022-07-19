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
    formatter = TimeFormatter.new(Time.now, formats)
    formatted = formatter.call
    unknown_formats = formatter.unknown_formats

    if unknown_formats.any?
      response("Unknown time format #{unknown_formats}\n", 400, headers)
    else
      response(formatted, 200, headers)
    end
  end

  def response(body, status, headers)
    Rack::Response.new(body, status, headers).finish
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def request_valid?(request)
    request.path == '/time'
  end
end
