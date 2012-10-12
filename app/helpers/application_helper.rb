module ApplicationHelper
  def lipsum(*args)
    require 'lorem'
    Lorem::Base.new(*args).output
  end
end
