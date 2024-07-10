# frozen_string_literal: true

require 'spec_helper'

describe RakeNPM::TaskSets::Scripts do
  include_context 'rake'

  it 'adds single run script task defined in package.json' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump({ scripts: { test: 'run tests' } })
    )

    namespace :npm do
      described_class.define
    end

    application = Rake.application

    expect(application).to(have_task_defined('npm:test'))
  end

  it 'adds many run script tasks defined in package.json' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump(
        {
          scripts: {
            test: 'run tests',
            start: 'start up',
            stop: 'shutdown'
          }
        }
      )
    )

    namespace :npm do
      described_class.define
    end

    application = Rake.application

    %w[test start stop].each do |script|
      expect(application).to(have_task_defined("npm:#{script}"))
    end
  end

  it 'includes only the specified scripts from package.json' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump(
        {
          scripts: {
            test: 'run tests',
            start: 'start up',
            stop: 'shutdown'
          }
        }
      )
    )

    namespace :npm do
      described_class.define(include: %w[start stop])
    end

    expect(Rake.application).not_to(have_task_defined('npm:test'))
  end

  it 'excludes all the specified scripts from package.json' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump(
        {
          scripts: {
            test: 'run tests',
            start: 'start up',
            stop: 'shutdown'
          }
        }
      )
    )

    namespace :npm do
      described_class.define(exclude: %w[start stop])
    end

    %w[start stop].each do |script|
      expect(Rake.application).not_to(have_task_defined("npm:#{script}"))
    end
  end

  it 'passes a nil directory to run script tasks by default' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump({ scripts: { test: 'run tests' } })
    )

    namespace :npm do
      described_class.define
    end

    task = Rake::Task['npm:test']

    expect(task.creator.directory).to(be_nil)
  end

  it 'defines tasks for scripts using package.json from the ' \
     'specified directory' do
    stub_package_json(
      path: './nested/package.json',
      contents: JSON.dump(
        {
          scripts: {
            test: 'run tests',
            start: 'start up',
            stop: 'shutdown'
          }
        }
      )
    )

    namespace :npm do
      described_class.define(directory: './nested')
    end

    %w[test start stop].each do |script|
      expect(Rake.application).to(have_task_defined("npm:#{script}"))
    end
  end

  it 'passes directory to defined run script tasks when specified' do
    stub_package_json(
      path: './nested/package.json',
      contents: JSON.dump(
        {
          scripts: {
            test: 'run tests',
            start: 'start up',
            stop: 'shutdown'
          }
        }
      )
    )

    namespace :npm do
      described_class.define(directory: './nested')
    end

    %w[test start stop].each do |script|
      task = Rake::Task["npm:#{script}"]

      expect(task.creator.directory).to(eq('./nested'))
    end
  end

  it 'passes script names to defined run script tasks' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump(
        {
          scripts: {
            test: 'run tests',
            start: 'start up',
            stop: 'shutdown'
          }
        }
      )
    )

    namespace :npm do
      described_class.define
    end

    %w[test start stop].each do |script|
      task = Rake::Task["npm:#{script}"]

      expect(task.creator.script).to(eq(script))
    end
  end

  it 'passes no argument names to run script tasks by default' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump({ scripts: { test: 'run tests' } })
    )

    namespace :npm do
      described_class.define
    end

    task = Rake::Task['npm:test']

    expect(task.arg_names).to(eq([]))
  end

  it 'passes the provided argument names to defined run script tasks ' \
     'when supplied' do
    argument_names = %i[deployment_identifier region]

    stub_package_json(
      path: './package.json',
      contents: JSON.dump(
        {
          scripts: {
            test: 'run tests',
            start: 'start up',
            stop: 'shutdown'
          }
        }
      )
    )

    namespace :npm do
      described_class.define(argument_names:)
    end

    %w[test start stop].each do |script|
      task = Rake::Task["npm:#{script}"]

      expect(task.arg_names).to(eq(argument_names))
    end
  end

  it 'passes no environment to run script tasks by default' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump({ scripts: { test: 'run tests' } })
    )

    namespace :npm do
      described_class.define
    end

    task = Rake::Task['npm:test']

    expect(task.creator.environment).to(eq({}))
  end

  it 'passes the provided environment to defined run script tasks ' \
     'when supplied' do
    stub_package_json(
      path: './package.json',
      contents: JSON.dump(
        {
          scripts: {
            test: 'run tests',
            start: 'start up',
            stop: 'shutdown'
          }
        }
      )
    )

    namespace :npm do
      described_class.define(environment: { SOME: 'env-var' })
    end

    %w[test start stop].each do |script|
      task = Rake::Task["npm:#{script}"]

      expect(task.creator.environment)
        .to(eq({ SOME: 'env-var' }))
    end
  end

  def stub_package_json(opts)
    allow(File)
      .to(receive(:read)
            .with(opts[:path])
            .and_return(opts[:contents]))
  end
end
