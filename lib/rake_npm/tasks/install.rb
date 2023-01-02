# frozen_string_literal: true

require 'rake_factory'
require 'ruby_npm'

module RakeNPM
  module Tasks
    class Install < RakeFactory::Task
      default_name :install
      default_description(RakeFactory::DynamicValue.new do |_t|
        'Install NPM dependencies'
      end)

      parameter :color, default: 'always'
      parameter :fund, default: false
      parameter :audit, default: true

      action do |task|
        puts 'Installing NPM dependencies...'
        RubyNPM.install(
          color: task.color,
          fund: task.fund,
          audit: task.audit
        )
      end
    end
  end
end
