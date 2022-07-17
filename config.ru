# frozen_string_literal: true

require_relative 'middleware/time_formatter'
require_relative 'app'

use TimeFormatter
run App.new
