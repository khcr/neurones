#!/bin/env ruby
# encoding: utf-8

class Admin::StylesController < Admin::BaseController
	before_filter only: [:destroy, :edit, :update] {|controller| controller.modify_right(G::Style)}

	def index
		respond_to do |format|
    	format.html
    	format.json { render json: Datatable.new(view_context, G::Style) }
  	end
	end

	def new 
		@style = G::Style.new
	end

	def create
		@style = G::Style.new(params[:g_style])
		@style.theme = true
		if @style.save
			flash[:success] = "Style ajouté"
			expire_page :controller => "g/styles", :action => "show"
			redirect_to admin_g_styles_path
		else
			render 'new'
		end
	end

	def edit
		@style = G::Style.find(params[:id])
	end

	def update
		@style =G::Style.find(params[:id])
		if @style.update_attributes(params[:g_style])
			flash[:success] = "Style enregistré"
			expire_page :controller => "g/styles", :action => "show"
			redirect_to admin_g_styles_path
		else
			render 'edit'
		end
	end

	def destroy
		G::Style.find(params[:id]).destroy
		flash[:success] = "Style supprimé"
		redirect_to admin_g_styles_path
	end
end