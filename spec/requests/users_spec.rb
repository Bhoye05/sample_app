#!/bin/env ruby
# encoding: utf-8
require 'spec_helper'
require 'prawn'

describe "Users" do

  describe "une inscription" do

    describe "ratée" do

      it "ne devrait pas créer un nouvel utilisateur" do
        lambda do
          visit signup_path
          fill_in "Nom d'utilisateur", :with => ""
          fill_in "Adresse mail", :with => ""
          fill_in "Mot de pass", :with => ""
          fill_in "Confirmation", :with => ""
	  fill_in "Date de naissance", :with => ""
	  fill_in "Poids", :with =>""
	  fill_in "Taille",:with =>""
	  fill_in "Déposer votre cv (pdf/word)", :with => "/home/bhoye/Dropbox/rails_projects/sample_app/caf.pdf" 
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end
    
    describe "réussie" do    
       
      it "devrait créer un nouvel utilisateurr" do
        lambda do
          visit signup_path
          fill_in "Nom d'utilisateur", :with => "Example User"
          fill_in "Adresse mail", :with => "user@example.com"
          fill_in "Mot de pass", :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
	  fill_in "Date de naissance", :with => "01/01/1980"
	  fill_in "Poids", :with => 50
	  fill_in "Taille", :with => 150
	  fill_in "Déposer votre cv (pdf/word)", :with => "/home/bhoye/Dropbox/rails_projects/sample_app/caf.pdf"
          click_button
	  
          response.should have_selector("div.flash.success",
                                        :content => "Bienvenue")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
  
  describe "identification/déconnexion" do

    describe "l'échec" do
      it "ne devrait pas identifier l'utilisateur" do
        visit signin_path
        fill_in "Adresse mail",    :with => ""
        fill_in "Mot de pass", :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Combinaison Email/Mot de passe invalide")
      end
    end

    describe "le succès" do
      it "devrait identifier un utilisateur puis le déconnecter" do
        user = Factory(:user)
        visit signin_path
        fill_in "Adresse mail",    :with => user.email
        fill_in "Mot de pass", :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Déconnexion"
        controller.should_not be_signed_in
      end
    end
  end
end
