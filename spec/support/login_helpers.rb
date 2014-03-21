module LoginHelper
	def log_in_as(user)
		Capybara.current_session.driver.submit :post, loginpost_path(:session => {:email => user.email, :password => user.password}), nil
	end
end
RSpec.configure do |c|
  c.include LoginHelper
end