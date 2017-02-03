require 'test_helper'
require 'rbconfig'
require 'byebug/helpers/string'

module Byebug
  #
  # Tests restarting functionality.
  #
  class RestartTest < TestCase
    include Helpers::StringHelper

    def setup
      super

      example_file.write(program)
      example_file.close
    end

    def program
      deindent <<-'RUBY', leading_spaces: 8
        #!/usr/bin/env ruby

        require 'English'
        require 'byebug'

        byebug

        if $ARGV.empty?
          print "Run program #{$PROGRAM_NAME} with no args"
        else
          print "Run program #{$PROGRAM_NAME} with args #{$ARGV.join(',')}"
        end
      RUBY
    end

    def test_restart_with_no_args_original_script_with_no_args_standalone_mode
      stdout = run_program("#{byebug_bin} #{example_path}", 'restart')

      assert_match(/Run program #{example_path} with no args/, stdout)
    end

    def test_restart_with_no_args_original_script_with_no_args_attached_mode
      stdout = run_program(example_path, 'restart')

      assert_match(/Run program #{example_path} with no args/, stdout)
    end

    def test_restart_with_no_args_original_script_through_ruby_attached_mode
      stdout = run_program("#{ruby_bin} #{example_path}", 'restart')

      assert_match(/Run program #{example_path} with no args/, stdout)
    end

    def test_restart_with_no_args_in_standalone_mode
      stdout = run_program("#{byebug_bin} #{example_path} 1", 'restart')

      assert_match(/Run program #{example_path} with args 1/, stdout)
    end

    def test_restart_with_args_in_standalone_mode
      stdout = run_program("#{byebug_bin} #{example_path} 1", 'restart 2')

      assert_match(/Run program #{example_path} with args 2/, stdout)
    end

    def test_restart_with_no_args_in_attached_mode
      stdout = run_program("#{example_path} 1", 'restart')

      assert_match(/Run program #{example_path} with args 1/, stdout)
    end

    def test_restart_with_args_in_attached_mode
      stdout = run_program("#{example_path} 1", 'restart 2')

      assert_match(/Run program #{example_path} with args 2/, stdout)
    end

    private

    def ruby_bin
      RbConfig.ruby
    end

    def byebug_bin
      Context.bin_file
    end
  end
end
