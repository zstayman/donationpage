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
    donation = {
      external_id: charge["id"],
      firstname: params[:first_name],
      lastname: params[:last_name],
      transaction_dt: Time.now.to_s,
      amount: params[:amount].to_i,
      cc_type_cd: cc_conversion(charge["card"]["type"]),
      addr1: params[:address_1],
      addr2: params[:address_2],
      city: params[:city],
      state: params[:state].downcase
    }.to_json
    binding.pry
    HTTParty.post("", donation)
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

    return cards[type]
  end
end
