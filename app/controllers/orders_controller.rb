# frozen_string_literal: true
class OrdersController < ApplicationController

  def new
    @products = Product.active.ordered
    @order = Order.new(gift: params[:gift], product: Product.find_by_name("1 year"))
  end

  def create
    order_params = params.require(:order).permit([:product_id, :gift, :payment_provider])
    if order_params["payment_provider"] == "stripe"
      pay_with_stripe(order_params)
    else
      pay_with_paypal(order_params)
    end
  end

  def redirect
    if order.charge(params[:PayerID])
      if order.gift?
        flash[:notice] = "Your payment has been received and we've given you a premium code that you can give away"
        redirect_to settings_path("#your-vouchers")
      else
        flash[:notice] = "Your payment has been received and your donator perks are now activated, thanks! <3"
        redirect_to root_path
      end
    else
      flash[:alert] = "Something went wrong while trying to activate your donator status, please check if you have sufficient funds in your PayPal account"
      redirect_to root_path
    end
  end

  def stripe_callback
    puts params.inspect
    Order.last.handle_successful_payment!
    head :ok
  end

  def paid_with_stripe
    order = current_user.stripe_orders.find(params.require(:order_id))
    render plain: { product_name: order.product_name, gift: order.gift, voucher: order.voucher.try(:code) }.to_json
  end

  def pay_with_paypal(order_params)
    paypal_order.product_id = order_params[:product_id].to_i
    paypal_order.gift       = order_params[:gift]
    if paypal_order.save && paypal_order.prepare
      redirect_to paypal_order.checkout_url
    else
      flash[:alert] = "Something went wrong creating your order, please try again"
      render :new
    end
  end

  def pay_with_stripe(order_params)
    $lock.synchronize("stripe-intent-#{current_user.id}") do
      order = current_user.stripe_orders.build
      order.product = Product.active.find_by_id(order_params["product_id"].to_i)
      order.gift = (order_params["gift"] == "true")
      order.save!
      @payment_intent = order.create_intent
      redirect_to paying_with_stripe_path(order_id: order.id, payment_intent: @payment_intent.client_secret)
    end
  end

  def paying_with_stripe
    order_id, payment_intent = params.require([:order_id, :payment_intent])
    @order = current_user.orders.joins(:product).find_by_id(order_id)
    @payment_intent = payment_intent
  end

  def order
    current_user.paypal_orders.find(params[:order_id].to_i)
  end

  def paypal_order
    @paypal_order ||= current_user.paypal_orders.build
  end

end
