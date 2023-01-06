# frozen_string_literal: true

require 'rake'
require 'rake_dependencies'

module RakeNPM
  module TaskSets
    class Scripts < RakeFactory::TaskSet
      parameter :directory

      parameter :include, default: nil
      parameter :exclude, default: nil

      parameter :environment, default: {}

      parameter :argument_names

      def define_on(application)
        around_define(application) do
          scripts.each_key do |script|
            define_run_script_on(
              application, { name: script, script: script }
            )
          end
        end

        self
      end

      private

      def scripts
        resolve_scripts(
          lookup_scripts(parameter_values[:directory]),
          parameter_values[:include],
          parameter_values[:exclude]
        )
      end

      def define_run_script_on(application, options)
        TaskSpecification
          .new(Tasks::RunScript, [options])
          .for_task_set(self)
          .define_on(application)
      end

      def lookup_scripts(directory)
        path = File.join(directory || '.', 'package.json')
        contents = JSON.parse(File.read(path))
        contents['scripts']
      end

      def resolve_scripts(scripts, include, exclude)
        include ||= scripts
        exclude ||= []

        scripts.select { |s| include.include?(s) }
               .reject { |s| exclude.include?(s) }
      end
    end
  end
end
