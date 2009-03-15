class CustomizesController < ApplicationController
  def index
    @customizes = Customize.find(:all)
  end
end
