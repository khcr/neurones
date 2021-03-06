#!/bin/env ruby
# encoding: utf-8

module GroupsHelper

  # Provide the group that is currently used
  #
  # * *Args*    :
  #
  # * *Returns* :
  #   - a group
  def current_group
    @group ||= Group.find_by_url(params[:group_id])
  end

  # Generate a complete url for group's page
  #
  # * *Args*    :
  #   - page's name
  # * *Returns* :
  #   - full url with group's name and page's name
  def page_url(page_url)
  	"/#{current_group.url}/#{page_url}"
  end

  # Generate a complete url for the admin group zone with a given name
  #
  # * *Args*    :
  #   - a group (default = current_group)
  # * *Returns* :
  #   - full url
  def index_url(group = current_group, name)
    "/admin/groups/#{group.url}/#{name}"
  end

  # Check if a module is activated or not
  #
  # * *Args*    :
  #   - the module to check
  # * *Returns* :
  #   - true or false
  def module_activated?(g_module)
    unless current_group.modules.pluck(:module_id).include? G::Module.find_by_name(g_module).id
      flash[:success] = "Non disponible"
      redirect_to root_path
    end
  end

  def update_attributes(style)
  	parsed_style = style.content.split(/(})/) #will leave the splitter
  	params[:style].each do |selector, sel_value|
  		sel_value.each do |attribute, value|
  			attribute = attribute.gsub(/_/, '-')
  			value = value.gsub(/[{};]/, '')
  			parsed_style.map! do |element|
  				element_selector = element.gsub(/{(.*)/m, '').strip
  					if element_selector == selector
              if attribute == 'background-image'
  						  element = element.gsub(/(^\s*#{attribute}).*?;/m, '\1:url(' + "#{value});")
              else
                element = element.gsub(/(^\s*#{attribute}).*?;/m, '\1:' + "#{value};")
              end
  					end
  					element
  				end
  				style.content = parsed_style.join
  				style.save
  		end
  	end
  end

  def get_attributes
  	style = current_group.style
  	parsed_style = style.content.split(/}/)
  	hash = {}
  	parsed_style.each do |element|
  		element_selector = element.gsub(/{(.*)/m, '').strip
  		element.gsub!(/(.*?){/m, '')
  		attributes = element.split(/;/)
  		hash_attr = {}
  		attributes.each do |attr|
        if !(splitted = attr.scan(/(.*?):(.*)/)).blank?
          hash_attr[splitted[0][0].strip] = splitted[0][0].strip == 'background-image'? splitted[0][1][4..-2].strip : splitted[0][1].strip
  		  end
      end
  		hash[element_selector] = hash_attr
  	end
  	return hash
  end

  def hash_attr(selector, attribute)
  	if @attributes.nil? || @attributes[selector].nil? || @attributes[selector][attribute].nil?
  		"!! Feuille de style corrompue (#{selector} : #{attribute})"
  	else
  		@attributes[selector][attribute].strip
  	end
  end

  def text_align
  	[['Gauche','left'], ['Centré','center'], ['Droite','right']]
  end

  def background_repeat
  	[['Répéter','repeat'], ['Répéter Horizontalement','repeat-x'], ['Répéter Verticalement','repeat-y'], ['Ne pas répéter','no-repeat']]
  end

  def background_position
  	[['Gauche Haut','left top'], ['Gauche Centré','left center'], ['Gauche Bas','left bottom'], ['Droite Haut','right top'], ['Droite Centré','right center'], ['Droite Bas','right bottom'], ['Centré Haut','center top'], ['Centré Centré','center center'], ['Centré Bas','center bottom']]
  end

end
