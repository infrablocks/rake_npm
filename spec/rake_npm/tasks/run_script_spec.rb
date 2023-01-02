# frozen_string_literal: true

require 'spec_helper'

describe RakeNPM::Tasks::RunScript do
  include_context 'rake'

  def define_task(opts = {}, &block)
    opts = {
      namespace: :npm,
      script: 'test'
    }.merge(opts)

    namespace opts[:namespace] do
      subject.define(opts, &block)
    end
  end

  it 'adds a run_script task in the namespace in which it is created' do
    define_task

    expect(Rake.application)
      .to(have_task_defined('npm:run_script'))
  end

  it 'uses the specified task name when provided' do
    define_task(
      name: :test
    )

    expect(Rake.application)
      .to(have_task_defined('npm:test'))
  end

  it 'gives the task a description' do
    define_task(
      script: 'start'
    )

    expect(Rake::Task['npm:run_script'].full_comment)
      .to(eq('Runs the NPM start script'))
  end

  it 'allows multiple run_script tasks to be declared' do
    define_task(namespace: :npm1)
    define_task(namespace: :npm2)

    expect(Rake.application).to(have_task_defined('npm1:run_script'))
    expect(Rake.application).to(have_task_defined('npm2:run_script'))
  end

  it 'runs the specified NPM script' do
    define_task(
      script: 'test'
    )

    stub_output
    stub_npm_run_script

    Rake::Task['npm:run_script'].invoke

    expect(RubyNPM)
      .to(have_received(:run_script)
            .with(hash_including(script: 'test')))
  end

  def stub_output
    %i[print puts].each do |method|
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end

  def stub_npm_run_script
    allow(RubyNPM).to(receive(:run_script))
  end
end
