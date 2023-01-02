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

      action do |_|
        puts 'Installing NPM dependencies...'
        RubyNPM.install
      end
    end
  end
end
