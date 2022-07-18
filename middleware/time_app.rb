# frozen_string_literal: true

require_relative '../formatters/time_formatter'

class TimeApp
  def initialize(_app); end

  def call(env)
    @request = Rack::Request.new(env)
    @formats = @request.params['format']
    formatter = TimeFormatter.new(Time.now, @formats)
    @formatted = formatter.format
    @unknown_formats = formatter.unknown_formats

    response
  end

  private

  def response
    @response = Rack::Response.new
    status
    headers
    body
    @response.finish
  end

  def status
    @response.status = 404 and return if @request.path != '/time'
    @response.status = 400 and return if formats_invalid?

    @response.status = 200
  end

  def headers
    @response.set_header('Content-Type', 'text/plain')
  end

  def body
    @response.write("Page not found\n") and return if @response.status == 404
    @response.write("Format not found\n") and return if @formats.nil?

    @response.write(@unknown_formats.any? ? "Unknown time format #{@unknown_formats}\n" : @formatted)
  end

  def formats_invalid?
    @formats.nil? || @unknown_formats.any?
  end
end
