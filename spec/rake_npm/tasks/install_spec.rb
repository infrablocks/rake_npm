# frozen_string_literal: true

require 'spec_helper'

describe RakeNPM::Tasks::Install do
  include_context 'rake'

  def define_task(opts = {}, &block)
    opts = { namespace: :npm }.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds an install task in the namespace in which it is created' do
    define_task

    expect(Rake.application)
      .to(have_task_defined('npm:install'))
  end

  it 'gives the task a description' do
    define_task

    expect(Rake::Task['npm:install'].full_comment)
      .to(eq('Install NPM dependencies'))
  end

  it 'allows multiple install tasks to be declared' do
    define_task(namespace: :npm1)
    define_task(namespace: :npm2)

    expect(Rake.application).to(have_task_defined('npm1:install'))
    expect(Rake.application).to(have_task_defined('npm2:install'))
  end
end
