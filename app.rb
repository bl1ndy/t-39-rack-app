# frozen_string_literal: true

class App
  def call(env)
    @env = env

    [status, headers, body]
  end
end

private

def status
  @env['REQUEST_PATH'] == '/time' ? 200 : 404
end

def headers
  { 'Content-Type' => 'text/plain' }
end

def body
  return ['404 Not found'] if status == 404

  ["Good day!\n"]
end
