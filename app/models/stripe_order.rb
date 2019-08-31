# frozen_string_literal: true
class StripeOrder < Order
  def create_intent
    Stripe::PaymentIntent.create({
      amount: product.price_in_cents,
      currency: product.currency,
      description: "#{SITE_URL} - #{product_name}",
      payment_method_types: ['card'],
      metadata: {
        site_url: SITE_URL,
        order_id: id,
        steam_uid: user.uid,
        product_name: product_name,
      }
    })
  end
end
