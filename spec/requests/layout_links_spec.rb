#!/bin/env ruby
# encoding: utf-8
require 'spec_helper'

describe "LayoutLinks" do
  it "devrait trouver une page Accueil à '/'" do
    get '/'
    response.should have_selector('title', :content => "Accueil")
  end

  it "devrait trouver une page Contact at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact")
  end

  it "should have an À Propos page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "A Propos")
  end

  it "devrait trouver une page Iade à '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Aide")
  end
  
  it "devrait avoir une page d'inscription à '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Inscription")
  end
  
  
  describe "quand pas identifié" do
    it "doit avoir un lien de connexion" do
      visit root_path
      response.should have_selector("a", :href => signin_path,
                                         :content => "Connexion")
    end
  end

  describe "quand identifié" do

    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in "Adresse mail",    :with => @user.email
      fill_in "Mot de pass", :with => @user.password
      click_button
    end

    it "devrait avoir un lien de déconnxion" do
      visit root_path
      response.should have_selector("a", :href => signout_path,
                                         :content => "Déconnexion")
    end

    it "devrait avoir un lien vers le profil" do
      visit root_path
      response.should have_selector("a", :href => user_path(@user),
                                         :content => "Profil")
    end
  end
end
