class OrdersController < ApplicationController
  before_action :find_order, only: [:show, :edit, :cart, :update]
  before_action :check_for_nil, only: [:show, :edit, :cart, :update]

  def new 
    @order = Order.new
  end

  def create 
    @order = Order.new(order_params)

  end

  def show
    if @order.status == "pending"
      redirect_to cart_path
      return
    end

    user_verification
  end

  def edit
    if @order.orderitems == [] || @order.orderitems.nil?
      redirect_to order_path(@order)
      return
    elsif @order.status == "complete"
      redirect_to order_path(@order)
      return
    end
  end

  def update
    if @order.update(order_params)
      flash[:success] = "Your order has been placed. Thank you!"
      redirect_to order_path(@cart)
      session[:cart_id] = nil
      return
    else
      render :edit
      return
    end
  end

  def cart
    @order = Order.find_by(id: @cart.id)
    if @order.status != "pending"
      redirect_to order_path(@order.id)
      return
    end
  end


  private

  def order_params
    return params.require(:order).permit(:status, :name, :email_address, :address, :city, :state, :zipcode, :cc_num, :cc_exp_month, :cc_exp_year, :cc_cvv, :order_date, :user_id)
  end

  def find_order
    @order = Order.find_by(id: params[:id])
  end

  def check_for_nil
    if @order.nil?
      redirect_back(fallback_location: root_path)
      return
    end
  end

  def user_verification
    order_users = []
    @order.order_items.each do |order_item|
      user = order_item.user

      order_users << user
    end

    unless order_users.include?(session[:user_id])
      redirect_to root_path
      return
    end
  end
end
