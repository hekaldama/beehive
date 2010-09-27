module BeehiveClient

  class CommandError < StandardError; end

  require 'beehive_client/commands/base'

  module Cli

    def self.run(command, argv=[])
      require 'optparse'

      begin
        run_command command, argv
      rescue BeehiveClient::CommandError => e
        BeehiveClient::Command::Help.new.
          run(:msg => "<red>Error with #{command}: #{e}</red>\n")
      rescue LoadError => e
        error "Unknown command. Run 'beehive help' for more information"
      rescue NameError => e
        BeehiveClient::Command::Help.new.
          run(:msg => "<red>Unknown command: #{command}</red>\n")
      rescue Exception => e
        p [:exception, e.inspect]
      end
    end

    def self.run_command(command, argv)
      command_klass = BeehiveClient::Command.const_get(command.camelcase).new(argv)
      command_klass.run
    end

    def self.error(msg)
      STDERR.puts(msg)
      exit 1
    end

  end

end
