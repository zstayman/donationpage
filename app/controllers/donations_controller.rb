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
    }
    time = Time.now.to_i
    HTTParty.post("https://trujillo.cp.bsd.net/page/api/contribution/add_external_contribution?api_ver=2&api_id=Signup-Donation&api_ts=#{time}&api_mac=#{hashify(donation)}", donation.to_json)
    binding.pyr
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

  def hashify(donation)
    signing_string = "Signup-Donation\ntime\n/page/api/contribution/add_external_contribution\napi_version=2&api_id"
    donation.each do |key, value|
      signing_string += "&#{key.to_s}=#{value}"
    end
    api_mac = OpenSSL::HMAC.hexdigest("sha1", BSD_SECRET, signing_string)
    return api_mac
  end
end
