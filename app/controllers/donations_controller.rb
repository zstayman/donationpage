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
    cont = BlueStateDigital::Contribution.new(connection: $CONNECTION,
                                              external_id: charge["id"],
                                              firstname: params[:first_name],
                                              lastname: params[:last_name],
                                              transaction_amt: params[:amount].to_i,
                                              cc_type_cd: cc_conversion(charge["card"]["type"]),
                                              transaction_dt: DateTime.now.to_s
                                              )
    cont.save
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
