class ApplicationController < ActionController::Base
  def hello
    render html: "Hello rail!"
  end

end
