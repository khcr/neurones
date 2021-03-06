#!/bin/env ruby
# encoding: utf-8

class Admin::GroupsController < Admin::BaseController
  before_filter :load_and_authorize_group, only: [:activation, :activate]
  before_filter :activated?, only: [:activation, :activate]
  load_and_authorize only: [:index, :new, :create]
  layout 'group/admin'

	def index
		@table = GroupTable.new(self)
    @table.respond
	end

	def new
		@group = Group.new
	end

	def create
		@group = Group.new(params[:group])
    @group.url = SecureRandom.uuid
    if @group.save
      flash[:success] = "Groupe ajouté"
      redirect_to admin_groups_path
    else
      render 'new'
    end
  end

  def edit
  	@group = Group.find_by_url(params[:id])
    load_and_authorize!(resource: @group)
  end

  def update
  	@group = Group.find_by_url(params[:id])
    load_and_authorize!(resource: @group)
  	if @group.update_attributes(params[:group])
      flash[:success] = "Groupe enregistré"
      redirect_to edit_admin_group_path(@group)
    else
      render 'edit'
    end
  end

  def destroy
  	@group = Group.find_by_url(params[:id])
    load_and_authorize!(resource: @group)
    @group.destroy
    flash[:success] = "Groupe supprimé"
    redirect_to admin_groups_path
  end

  def activation
  end

  def activate
    @group.url = params[:group][:url]
    if @group.valid?
      @group.website_activated = true

      # create the stylesheet
      theme = G::Style.find_by_name_and_theme('default', true)
      style = G::Style.new(name: @group.name, content: theme.content)
      style.theme = false
      style.save
      @group.style_id = style.id

      @group.save
      @group.pages.create(page_order: 1, url: "index", name: "Index")

      flash[:success] = "Site activé"
      redirect_to edit_admin_group_path(@group)
    else
      @group.url = @group.url_was
      render 'activation'
    end
  end

  private

  # prevent access to activation if already activated

  def activated?
    # @group comes from #load_and_authorize_group
    redirect_to edit_admin_group_path(@group) unless !@group.website_activated
  end

end
