require 'byebug'

class Argument

	attr_reader :key, :long_key, :desc, :type

	def initialize(key_sym, long_key, desc)
		@key = key_sym
		@long_key = long_key
		@desc = desc
	end
end

class FlagArgument < Argument
	def initialize(key_sym, long_key, desc)
		super
		@type = :flag
	end
end

class ArgumentParser
	private_class_method :new

	def self.instance
		@instance ||= new
	end

	@@REGISTERED_ARGS = {}

	class << self
		def flag_argument(key_sym, long_key, desc)
			flag_arg = FlagArgument.new(key_sym, long_key, desc)
			(@@REGISTERED_ARGS[flag_arg.type.intern] ||=[]) << flag_arg
		end
	end

	attr_reader :opts

	# Method calls runs once class is initialised
	flag_argument(:v, "--verbose", "Ensures verbosity in the program")
	flag_argument(:a, "--alpha", "Set a random alpha target")
	flag_argument(:b, "--beta", "Set a random beta target")
	flag_argument(:c, "--cosine", "Set a random cosine angle")

	def initialize
		@opts = {}
	end

	def run(arguments = ARGV)
		if arguments.class == String
			arguments = arguments.split(' ')
		end
		parse_cmd_arguments(arguments)
		puts(opts)
	end

	def registered_args
		@@REGISTERED_ARGS
	end

	private

	def parse_cmd_arguments(argument_vector)
		argument_vector.each_with_index do |token, index|
			case token
			when /-([a-z]*)/
				$1.split('').each do |flag_token|
					parse_flag(flag_token)
				end
			when /-([a-z])/
				parse_flag($1)
			end
		end 
	end

	def parse_flag(flag_argument)
		if @@REGISTERED_ARGS[:flag].map(&:key).include? flag_argument.intern
			@opts[flag_argument.intern] = true
		end
	end

end


'''
	ruby my-ls.rb -v -abc
'''
ArgumentParser.instance.run