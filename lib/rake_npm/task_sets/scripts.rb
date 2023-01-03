# frozen_string_literal: true

require 'rake'
require 'rake_dependencies'

module RakeNPM
  module TaskSets
    class Scripts < RakeFactory::TaskSet
      parameter :directory, default: '.'

      def define_on(application)
        scripts = lookup_scripts(parameter_values[:directory])

        around_define(application) do
          scripts.keys.each do |script|
            options = { name: script, script: script }
            TaskSpecification
              .new(Tasks::RunScript, [options])
              .for_task_set(self)
              .define_on(application)
          end
        end

        self
      end

      private

      def lookup_scripts(directory)
        path = File.join(directory, 'package.json')
        contents = JSON.parse(File.read(path))
        contents['scripts']
      end
    end
  end
end
