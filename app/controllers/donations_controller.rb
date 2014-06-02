class DonationsController < ApplicationController
  def new
  end
  def create
    binding.pry
    redirect_to request.referer
  end
end
