class DonationsController < ApplicationController
  def new
  end
  def create
    charge = Stripe::Charge.create(
      amount: (params[:amount].to_i * 100),
      currency: "usd",
      card: params[:stripeToken],
      description: "TEST Web Donation",
      )
    redirect_to request.referer
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to request.referer
  end

  private

  def cc_conversion(type)
    cards = {
      "Visa" => 'vs',
      "MasterCard" => 'mc',
      "American Express" => 'ax',
      "Discover" => 'ds'
    }

    cards[type]
  end

end
