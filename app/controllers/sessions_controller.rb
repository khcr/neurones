#!/bin/env ruby
# encoding: utf-8

class SessionsController < ApplicationController

	def plus
	end

	def login
	end

	def create
		params[:session][:email] = params[:session][:email].gsub(/\s+/, "").downcase
		user = User.find_by_email(params[:session][:email])
		if user && user.authenticate(params[:session][:password])
			params[:session][:remember_me] == '1' ? sign_in_permanent(user) : sign_in(user)
			respond_to do |format|
      	format.html { redirect_to(root_path, notice: "Connexion réussie.") }
      	format.js { render 'create_success' }
    	end
		else
			flash.now[:error] = "Nom d'utilisateur ou/et mot de passe incorrect."
			respond_to do |format|
      	format.html { render 'login' }
      	format.js { render 'create_error' }
    	end
		end
	end

	# call back from mniauth
	def check_external
		#raise env['omniauth.auth'].to_yaml
		if env['omniauth.auth']['info']['name'].nil?
			redirect_to root_path, notice: 'veuillez compléter votre profil github avec votre nom.'
		else
			if (user = User.from_omniauth(env['omniauth.auth'])).nil?
				user = User.create_from_omniauth(env['omniauth.auth'])
				sign_in(user)
				redirect_to root_path, notice: "Un nouveau compte à été créé!"
			else
				sign_in(user)
				redirect_to root_path, notice: "Vous êtes connecté."
			end 
		end
	end

	def destroy 
		sign_out
	end
end
