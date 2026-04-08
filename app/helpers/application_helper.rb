module ApplicationHelper
  def icon(icon, text=nil)
    "<i class='fa fa-#{icon}' aria-hidden='true'> #{text}</i>".html_safe
  end

  def query_result_details(query, total)
    "<p class='query-result-details'>Search: #{total} #{'result'.pluralize(total)} for \"#{query}\"</p>".html_safe if query
  end

  def search_filters(params)
    filters = "<ul class='search-filters list-unstyled'>"
    filters += "<li>#{link_to icon('times'), remove_filter(params, :band_id)} <strong>Band</strong>: <em>#{Band.find(params[:band_id]).name}</em></li>" if params[:band_id]
    filters += "<li>#{link_to icon('times'), remove_filter(params, :venue_id)} <strong>Venue</strong>: <em>#{Venue.find(params[:venue_id]).name}</em></li>" if params[:venue_id]
    filters += "<li>#{link_to icon('times'), remove_filter(params, :show_id)} <strong>Show</strong>: <em>#{Show.find(params[:show_id]).display_name} at #{Show.find(params[:show_id]).venue.name}</em></li>" if params[:show_id]
    filters += "</ul>"
    filters.html_safe
  end

  def filter_params(params)
    filters = {}
    # Rails wouldn't let me mess with ActionController::Parameters
    # so I had to rebuild, but I think it's better this way.
    filters[:band_id] = params[:band_id] if params[:band_id]
    filters[:venue_id] = params[:venue_id] if params[:venue_id]
    filters[:show_id] = params[:show_id] if params[:show_id]
    filters[:q] = params[:q] if params[:q]
    filters
  end

  def remove_filter(params, filter)
    filters = filter_params(params)
    filters.delete(filter)
    videos_path(filters)
  end

  def links_for(object)
    links = ""
    links += "<li class='list-inline-item fs-3'>#{link_to icon('globe'), object.website, target: '_blank'}</li>" if object.website?
    links += "<li class='list-inline-item fs-3'>#{link_to icon('facebook-square'), object.facebook, target: '_blank'}</li>" if object.facebook?
    links += "<li class='list-inline-item fs-3'>#{link_to icon('instagram'), object.instagram, target: '_blank'}</li>" if object.instagram?
    links += "<li class='list-inline-item fs-3'>#{link_to icon('twitter'), object.twitter, target: '_blank'}</li>" if object.twitter?

    if object.class.name == "Band"
      links += "<li class='list-inline-item fs-3'>#{link_to icon('bandcamp'), object.bandcamp, target: '_blank'}</li>" if object.bandcamp?
      links += "<li class='list-inline-item fs-3'>#{link_to icon('soundcloud'), object.soundcloud, target: '_blank'}</li>" if object.soundcloud?
    end

    links.html_safe
  end

  def status_for(object)
    status_button = if object.published?
      link_to "Published", "#", class: 'btn btn-sm btn-success', disabled: true
    elsif object.is_a?(Show) && object.ready?
      link_to "Ready to Publish!", admin_path, class: 'btn btn-sm btn-danger'
    else
      link_to "Draft", "#", class: 'btn btn-sm btn-info', disabled: true
    end

    status_button
  end

  def image_url_for(object)
    return "placeholder.png" if Rails.env.development?

    if object.image.attached?
      url_for(object.image)
    else
      "https://placehold.co/1200x600/050b27/FFF?text=#{object.name}&t=#{rand(1000000)}"
    end
  end

  # change the default link renderer for will_paginate
  def will_paginate(collection_or_options = nil, options = {})
    if collection_or_options.is_a? Hash
      options, collection_or_options = collection_or_options, nil
    end
    unless options[:renderer]
      options = options.merge :renderer => BootstrapPagination::Rails
    end
    super *[collection_or_options, options].compact
  end
end
