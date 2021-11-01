# !/usr/bin/env ruby
# Otto Santovenia, Luis Manuel Alfred, 1190173, 28.10.2021

require "./00-eksteuer"
require "test/unit"
class MyFirstTestsForWebEng < Test::Unit::TestCase

	def setup
		@e = Einkommen.new()
	end

	def test_grenzsteuersatz
		assert_in_delta 0.0, @e.grenzsteuersatz(9408.99), 0.0001
		assert_equal 0.14, @e.grenzsteuersatz(9409.99)
		assert_equal 0.2397, @e.grenzsteuersatz(14533)
		assert_equal 0.42, @e.grenzsteuersatz(57052)
		assert_equal 0.45, @e.grenzsteuersatz(270501)
		assert_equal 0.45, @e.grenzsteuersatz(10000000000000000)
		assert_equal 0.1515, @e.grenzsteuersatz(10000)
		assert_equal 0.0, @e.grenzsteuersatz(-10000)
  	end

	  def test_einkommensteuer
		assert_in_delta 0.0, @e.ek_steuer(9408.99), 0.0001
		assert_equal 0.14, @e.ek_steuer(9409.99)
		assert_equal 1283.89, @e.ek_steuer(14533)
		assert_equal 14998.1, @e.ek_steuer(57052)
		assert_equal 104646.71, @e.ek_steuer(270501)
		assert_equal 86.14, @e.ek_steuer(10000)
		assert_equal 0.0, @e.grenzsteuersatz(-10000)
  	end
end

