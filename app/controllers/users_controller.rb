class UsersController < ApplicationController
  
   def show
    @user = User.find(params[:id])
    @titre = @user.nom
  end
  
  def new
    @title = "Inscription"
  end
end
