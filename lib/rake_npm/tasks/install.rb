# frozen_string_literal: true

require 'rake_factory'
require 'ruby_npm'

require_relative '../mixins/directoried'

module RakeNPM
  module Tasks
    class Install < RakeFactory::Task
      include Mixins::Directoried

      default_name :install
      default_description(RakeFactory::DynamicValue.new do |_t|
        'Install NPM dependencies'
      end)

      parameter :color, default: 'always'
      parameter :fund, default: false
      parameter :audit, default: true

      parameter :directory

      parameter :environment, default: {}

      action do |task|
        logged_directory = task.directory || '.'
        puts(
          'Installing NPM dependencies ' \
          "in directory: '#{logged_directory}'..."
        )
        in_directory(task.directory) do
          RubyNPM.install(
            {
              color: task.color,
              fund: task.fund,
              audit: task.audit
            },
            {
              environment: task.environment
            }
          )
        end
      end
    end
  end
end
