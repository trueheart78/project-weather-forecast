require "simplecov"

SimpleCov.minimum_coverage 77
SimpleCov.start "rails" unless ENV["SKIP_COVERAGE"]
