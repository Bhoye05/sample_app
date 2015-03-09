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

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :nom, :email, :password, :password_confirmation, :date_naissance, 
                  :age, :poids, :poids_ideal, :attach, :taille, :attach_file_name  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  date_naissance_regex= /\d+\/\d+\/\d{4}/
  validates :nom, :presence => true, :length   => { :maximum => 50 }
  validates :email, :presence => true, :format   => { :with => email_regex }, :uniqueness => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 0..40 }
  validates :date_naissance, :presence => true, :format => {:with => date_naissance_regex }
  validates :poids, :presence => true
  validates :taille, :presence => true
  
  has_attached_file :attach, presence => true;
   
 
  
  before_save :encrypt_password, :calculer, :calcule_imc

  def has_password?(password_soumis)
    encrypted_password == encrypt(password_soumis)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end 
  
  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def calculer
    self.age=calcule_age(date_naissance)
  end
  
  #=========calcule de l'IMC===================#
  def calcule_imc
    tailleEnmetre = taille/100
    chaine = (Float (poids/(tailleEnmetre*tailleEnmetre))).to_s
    sous_chaine = chaine[0,5]
    return sous_chaine
  end
  
  #=========methode calcule de l'age===============#
  def calcule_age(string)
    tab_date = string.split('/')
    tempsActuel = Time.now.year    
    anneeNaissance = tab_date[2] 
    return nil  if Float(anneeNaissance)>tempsActuel   
    return Float(tempsActuel)-Float(anneeNaissance)    
  end 
 #===========verifer poids===============# 
  def verifier
    
  end
 
  private
     #=========methodes encodage de mot de passe=========#
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end   
end
