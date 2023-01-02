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

  it 'installs npm dependencies' do
    define_task

    stub_output
    stub_npm_install

    Rake::Task['npm:install'].invoke

    expect(RubyNPM).to(have_received(:install))
  end

  it 'passes a color parameter of "always" by default' do
    define_task

    stub_output
    stub_npm_install

    Rake::Task['npm:install'].invoke

    expect(RubyNPM)
      .to(have_received(:install)
            .with(hash_including(color: 'always')))
  end

  it 'passes the provided value for the color parameter when present' do
    define_task do |task|
      task.color = false
    end

    stub_output
    stub_npm_install

    Rake::Task['npm:install'].invoke

    expect(RubyNPM)
      .to(have_received(:install)
            .with(hash_including(color: false)))
  end

  it 'passes a fund parameter of false by default' do
    define_task

    stub_output
    stub_npm_install

    Rake::Task['npm:install'].invoke

    expect(RubyNPM)
      .to(have_received(:install)
            .with(hash_including(fund: false)))
  end

  it 'passes the provided value for the fund parameter when present' do
    define_task do |task|
      task.fund = true
    end

    stub_output
    stub_npm_install

    Rake::Task['npm:install'].invoke

    expect(RubyNPM)
      .to(have_received(:install)
            .with(hash_including(fund: true)))
  end

  it 'passes an audit parameter of true by default' do
    define_task

    stub_output
    stub_npm_install

    Rake::Task['npm:install'].invoke

    expect(RubyNPM)
      .to(have_received(:install)
            .with(hash_including(audit: true)))
  end

  it 'passes the provided value for the audit parameter when present' do
    define_task do |task|
      task.audit = false
    end

    stub_output
    stub_npm_install

    Rake::Task['npm:install'].invoke

    expect(RubyNPM)
      .to(have_received(:install)
            .with(hash_including(audit: false)))
  end

  def stub_output
    %i[print puts].each do |method|
      allow($stdout).to(receive(method))
      allow($stderr).to(receive(method))
    end
  end

  def stub_npm_install
    allow(RubyNPM).to(receive(:install))
  end
end
