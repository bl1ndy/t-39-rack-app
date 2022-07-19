# frozen_string_literal: true

require_relative 'middleware/time_app'
require_relative 'app'

use TimeApp
run App.new
