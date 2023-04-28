require 'rspec/autorun'
require_relative './cmd-app.rb'
require 'byebug'

describe ArgumentParser do

	it "initialises the flag argument definitions" do
		app = ArgumentParser.instance
		app.run("-abc")
	end

end