class SiteController < ApplicationController
  before_action :authenticate_user!
  layout 'index'

  def index
    @accounts = Account.all
  end
  def show
    @accounts = Account.find(params[:id])
  end
end
