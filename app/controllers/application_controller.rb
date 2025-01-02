class ApplicationController < ActionController::Base
  before_action :authenticate_user!
end


class PublicController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
end
