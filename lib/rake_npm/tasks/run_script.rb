# frozen_string_literal: true

require 'rake_factory'
require 'ruby_npm'

module RakeNPM
  module Tasks
    class RunScript < RakeFactory::Task
      default_name :run_script
      default_description(RakeFactory::DynamicValue.new do |t|
        "Runs the NPM #{t.script} script"
      end)

      parameter :script, required: true

      action do |task|
        puts "Running NPM script: '#{task.script}'..."
        RubyNPM.run_script(
          script: task.script
        )
      end
    end
  end
end
