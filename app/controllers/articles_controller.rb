#!/bin/env ruby
# encoding: utf-8

class ArticlesController < ApplicationController

	# store article's likes in a cookie

	def vote
		@article = Article.find(params[:id])
		cookies.permanent['article_votes'] = "" if !cookies['article_votes']
		if !cookies['article_votes'].split('&').include? @article.id.to_s 
			@article.likes += 1
			@article.save
			cookies.permanent['article_votes'] = cookies['article_votes'].split('&') + [@article.id]
			respond_to do |format|
				format.js
	    end
	  else
	  	respond_to do |format|
				format.js { render 'voted' }
	    end
	  end
	end

	def index
		if params[:auteur]
			@articles = Article.where('user_id = ?', params[:auteur].to_i)
		else
			@articles = Article.order('created_at DESC')
		end
	end

	def show
		@article = Article.find(params[:id])
	end
end
