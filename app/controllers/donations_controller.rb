class DonationsController < ApplicationController
  def new
  end
  def create
    binding.pry
    charge = Stripe::Charge.create(
      amount: (params[:amount].to_i * 100),
      currency: "usd",
      card: params[:stripeToken],
      description: "TEST Web Donation"
      )
    binding.pry
    redirect_to request.referer
  end
end
