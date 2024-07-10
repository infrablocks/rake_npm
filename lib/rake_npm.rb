# frozen_string_literal: true

require 'rake_npm/tasks'
require 'rake_npm/task_sets'
require 'rake_npm/version'

module RakeNPM
  def self.define_install_task(opts = {}, &)
    RakeNPM::Tasks::Install.define(opts, &)
  end

  def self.define_script_tasks(opts = {}, &)
    RakeNPM::TaskSets::Scripts.define(opts, &)
  end
end
