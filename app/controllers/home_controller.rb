class HomeController < ApplicationController
  def index
    @homes = Home.order(:name).page(1)
  end
end
