# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RakeNPM do
  it 'has a version number' do
    expect(RakeNPM::VERSION).not_to be_nil
  end

  describe 'define_script_tasks' do
    context 'when instantiating RakeNPM::TaskSets::Scripts' do
      it 'passes the provided block' do
        opts = {}

        block = lambda do |t|
          t.directory = './lib'
        end

        allow(RakeNPM::TaskSets::Scripts).to(receive(:define))

        described_class.define_script_tasks(opts, &block)

        expect(RakeNPM::TaskSets::Scripts)
          .to(have_received(:define) do |passed_opts, &passed_block|
            expect(passed_opts).to(eq(opts))
            expect(passed_block).to(eq(block))
          end)
      end
    end
  end
end
