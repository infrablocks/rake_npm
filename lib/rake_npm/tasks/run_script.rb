# frozen_string_literal: true

require 'rake_factory'
require 'ruby_npm'

require_relative '../mixins/directoried'

module RakeNPM
  module Tasks
    class RunScript < RakeFactory::Task
      include Mixins::Directoried

      default_name :run_script
      default_description(RakeFactory::DynamicValue.new do |t|
        "Runs the NPM #{t.script} script"
      end)

      parameter :script, required: true
      parameter :arguments

      parameter :color, default: 'always'

      parameter :environment, default: {}

      parameter :directory

      action do |task|
        logged_directory = task.directory || '.'
        puts(
          "Running NPM script: '#{task.script}' " \
          "in directory: '#{logged_directory}'..."
        )

        in_directory(task.directory) do
          RubyNPM.run_script(
            {
              script: task.script,
              arguments: task.arguments,
              color: task.color
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
