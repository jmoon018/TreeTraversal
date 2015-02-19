class Lknsagla < ActiveRecord::Base
	attr_accessor :something
	def initialize
		@something = 0
	end
end

x = Lknsagla.new

puts Lknsagla.attributes
