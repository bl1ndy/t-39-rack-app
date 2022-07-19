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
    formatter.call

    if formatter.valid?
      response(formatter.result, 200, headers)
    else
      response("Unknown time format #{formatter.unknown_formats}\n", 400, headers)
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
