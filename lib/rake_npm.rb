# frozen_string_literal: true

require 'rake_npm/tasks'
require 'rake_npm/task_sets'
require 'rake_npm/version'

module RakeNPM
  def self.define_install_task(opts = {}, &block)
    RakeNPM::Tasks::Install.define(opts, &block)
  end

  class << self
    private

    def configure_ruby_npm(binary)
      RubyNPM.configure { |c| c.binary = binary }
    end
  end
end
