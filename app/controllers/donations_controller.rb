class DonationsController < ApplicationController
  def new
  end
  def create
    Stripe::Charge.create(
      amount: params[:amount].to_i,
      currency: "usd",
      card: params[:stripeToken],
      description: "TEST Web Donation"
      )
    redirect_to request.referer
  end
end
