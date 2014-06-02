class DonationsController < ApplicationController
  def new
  end
  def create
    charge = Stripe::Charge.create(
      amount: (params[:amount].to_i * 100),
      currency: "usd",
      card: params[:stripeToken],
      description: "TEST Web Donation"
      )
    redirect_to request.referer
  rescue Stripe::CardError => e
    flash[:error] = e.message
    render json: flash[:error]

  end
end
