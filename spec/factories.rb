# En utilisant le symbole ':user', nous faisons que
# Factory Girl simule un modèle User.
Factory.define :user do |user|
  user.nom                  "Michael Hartl"
  user.email                 "mhartl@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.date_naissance        "00/00/0000"
  user.poids                 50
  user.taille                150
  #user.attach                "/home/bhoye/Dropbox/rails_projects/sample_app/caf.pdf"
end