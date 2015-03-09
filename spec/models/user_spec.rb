#!/bin/env ruby
# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  nom                   :string(255)
#  email                 :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  encrypted_password    :string(255)
#  salt                  :string(255)
#  date_naissance        :string(255)
#  age                   :float
#  poids                 :float
#  poids_ideal           :float
#  fais_regime           :boolean
#  aimerais_faire_regime :boolean
#  taille                :float
#  attach_file_name      :string(255)
#  attach_content_type   :string(255)
#  attach_file_size      :integer
#  attach_updated_at     :datetime
#

require 'spec_helper'

describe User do
     
  before(:each) do
    @attr = {
      :nom => "Utilisateur exemple",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar",
      :date_naissance => "00/00/0000",
      :poids => 0,
      :poids_ideal => 0,
      :taille => 150
    }
  end

      it "devrait créer une nouvelle instance dotée des attributs valides" do
	User.create!(@attr)
      end

      it "exige un nom" do
	bad_guy = User.new(@attr.merge(:nom => ""))
	bad_guy.should_not be_valid
      end
  
      it "exige une adresse email" do
	no_email_user = User.new(@attr.merge(:email => ""))
	no_email_user.should_not be_valid
      end
  
      it "devrait rejeter les noms trop longs" do
	long_nom = "a" * 51
	long_nom_user = User.new(@attr.merge(:nom => long_nom))
	long_nom_user.should_not be_valid
      end
  
      it "devrait accepter une adresse email valide" do
	adresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
	adresses.each do |address|
	  valid_email_user = User.new(@attr.merge(:email => address))
	  valid_email_user.should be_valid
	end
      end

      it "devrait rejeter une adresse email invalide" do
	adresses = %w[user@foo,com user_at_foo.org example.user@foo.]
	adresses.each do |address|
	  invalid_email_user = User.new(@attr.merge(:email => address))
	  invalid_email_user.should_not be_valid
	end
      end  
  
      it "devrait rejeter un email double" do
	# Place un utilisateur avec un email donné dans la BD.
	User.create!(@attr)
	user_with_duplicate_email = User.new(@attr)
	user_with_duplicate_email.should_not be_valid
      end
  
      it "devrait rejeter une adresse email invalide jusqu'à la casse" do
	upcased_email = @attr[:email].upcase
	User.create!(@attr.merge(:email => upcased_email))
	user_with_duplicate_email = User.new(@attr)
	user_with_duplicate_email.should_not be_valid
      end
 
      #=============description de l'age=====================#
      
       it "devrait accepter un format de date valide" do
	     dates = %w[00/00/0000 20/12/1950 12/08/2012]
	     dates.each do |dates|
	       valid_format_date = User.new(@attr.merge(:date_naissance => dates))
	       valid_format_date.should be_valid
	     end
       end
       
       it "devrait rejetter un format de date non valide" do
	     dates = %w[00-00-0000 20,12,1950 12;08;2012, 00*00*0000]
	     dates.each do |dates|
	       invalid_format_date = User.new(@attr.merge(:date_naissance => dates))
	       invalid_format_date.should_not be_valid
	     end
       end
             
      #=============description du mot de passe==============#
      describe "password validation" do
	
	      before(:each) do
	        @user = User.create!(@attr)
	      end
	      
	    it "devrai exiger un mot de passe" do
	      User.new(@attr.merge(:password =>"", :password_confirmation =>"")).should_not be_valid
	    end
	
	    it "devrait exiger une confirmation du mot de passe qui correspond" do
	      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
	    end

	    it "devrait rejeter les mots de passe (trop) courts" do
	      short = "a" * 5
	      hash = @attr.merge(:password => short, :password_confirmation => short)
	      User.new(hash).should_not be_valid
	    end

	    it "devrait rejeter les (trop) longs mots de passe" do
	      long = "a" * 41
	      hash = @attr.merge(:password => long, :password_confirmation => long)
	      User.new(hash).should_not be_valid
	    end
      end  
    
  #==============encrypted_password==============#
      describe "password encryption" do

	    before(:each) do
	      @user = User.create!(@attr)
	    end

	    it "devrait avoir un attribut  mot de passe crypté" do
	      @user.should respond_to(:encrypted_password)
	    end
    
	    it "devrait définir le mot de passe crypté" do
	    @user.encrypted_password.should_not be_blank
	    end  
    
	    describe "Méthode has_password?" do
		  it "doit retourner true si les mots de passe coïncident" do
		    @user.has_password?(@attr[:password]).should be_true
		  end    

		  it "doit retourner false si les mots de passe divergent" do
		    @user.has_password?("invalide").should be_false
		  end 
	    end 
	    
	    #=============autentification===============#
	    describe "authenticate method" do

	    it "devrait retourner nul en cas d'inéquation entre email/mot de passe" do
	      wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
	      wrong_password_user.should be_nil
	    end

	    it "devrait retourner nil quand un email ne correspond à aucun utilisateur" do
	      nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
	      nonexistent_user.should be_nil
	    end

	    it "devrait retourner l'utilisateur si email/mot de passe correspondent" do
	      matching_user = User.authenticate(@attr[:email], @attr[:password])
	      matching_user.should == @user
	    end
       end	    
     end
end
