class HomeController < ApplicationController
  def index
    @sections = Event.current.sections.order(:position)
    @classes = %w[one two three four five six seven eight nine]
  end
end
