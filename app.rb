# frozen_string_literal: true

class App
  def call(env)
    [status, headers, body]
  end
end

private

def status
  200
end

def headers
  { 'Content-Type' => 'text/plain' }
end

def body
  ["Good day!\n"]
end
