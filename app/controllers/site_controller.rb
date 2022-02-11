class SiteController < ApplicationController
  before_action :authenticate_user!
  layout 'index'

  def index
      @accounts = Account.find_by_user_id(current_user.id)
  end
  def show
    @accounts = Account.find(params[:id])
  end
end
