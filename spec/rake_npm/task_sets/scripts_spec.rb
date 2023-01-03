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

  def stub_package_json(opts)
    allow(File)
      .to(receive(:read)
            .with(opts[:path])
            .and_return(opts[:contents]))
  end
end
