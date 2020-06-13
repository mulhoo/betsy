class OrderitemsController < ApplicationController
  
  def index
    
  end

  # Reference: https://stackoverflow.com/questions/7980438/saving-cart-object-during-one-session

  def create
    if !session[:cart]
      session[:cart] = Array.new
    end 

    session[:cart] << params["product_id"]
    flash[:status] = :success
    flash[:result_text] = "Item added to shopping cart."
    redirect_to product_path(params["product_id"])
    return 
  end


end
