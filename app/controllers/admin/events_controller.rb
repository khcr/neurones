#!/bin/env ruby
# encoding: utf-8

class Admin::EventsController < Admin::BaseController
	load_and_authorize

	def index
		@table = Table.new(self, Event, @events)
	  @table.respond
	end

	def new
		@event = Event.new
	end

	def create
		@event = Event.new(params[:event])
		if @event.save
			flash[:success] = "Evénement ajouté"
			redirect_to admin_events_path
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @event.update_attributes(params[:event])
			flash[:success] = "Evénement enregistrée"
			redirect_to admin_events_path
		else
			render 'edit'
		end
	end

	def destroy
		@event.destroy
		flash[:success] = "Evénement supprimé"
		redirect_to admin_events_path
	end

end
