# frozen_string_literal: true

require 'rake_factory'

module RakeNPM
  module Tasks
    class Install < RakeFactory::Task
      default_name :install
      default_description(RakeFactory::DynamicValue.new do |_t|
        'Install NPM dependencies'
      end)

      action do |task|
        # no-op
      end
    end
  end
end
