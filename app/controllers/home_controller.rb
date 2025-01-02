class HomeController < ApplicationController
  def hello
    render plain: "Hello #{current_user.email}!"
  end
end
