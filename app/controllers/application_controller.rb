class ApplicationController < ActionController::Base
  include SessionsHelper
  def hello
    render html: "Hello rail!"
  end

end
