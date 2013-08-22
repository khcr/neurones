#!/bin/env ruby
# encoding: utf-8

class G::EventsController < G::BaseController

	def show
    unless @event = G::Event.find_by_group_id_and_id(current_group.try(:id), params[:id])
      render 'public/404'
    end
  end
end
