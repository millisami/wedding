class PagesController < ApplicationController
  layout nil
  def show
    begin
      @page = Page.find(params[:id])
    rescue
      @page = Page.new
      @page.id    = 1
      @page.position = 1
      @page.title = "No page exists with id=#{params[:id]}"
      @page.body  = "No page exists with id=#{params[:id]}<br/><br/>"+
          "Your administrator should login and do this unless you entered the id manually."
    end
    respond_to do |format|
      format.html # show.html.erb
    end
  end

end
