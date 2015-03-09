#!/bin/env ruby
# encoding: utf-8

require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do

    it "devrait réussir" do
      get :new
      response.should be_success
    end

    it "devrait avoir le bon titre" do
      get :new
      response.should have_selector("title", :content => "Identification")
    end
  end
  
  
  
  describe "POST 'create'" do

    describe "invalid signin" do

      before(:each) do
        @attr = { :nom => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar", 
	          :date_naissance => "01/01/1980", :poids => 75, :taille => 150,
	          :attach => "/home/bhoye/Dropbox/rails_projects/sample_app/caf.pdf"
	        }
      end

      it "devrait re-rendre la page new" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "devrait avoir le bon titre" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Identification")
      end

      it "devait avoir un message flash.now" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    
    describe "avec un email et un mot de passe valides" do

      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "devrait identifier l'utilisateur" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "devrait rediriger vers la page d'affichage de l'utilisateur" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    end
  end
  
  describe "DELETE 'destroy'" do

    it "devrait déconnecter un utilisateur" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end
end