class SitesController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:asset]
  layout nil, only: :show

  def index
    @sites = Site.all
    @site = Site.new
  end

  def asset
    puts "#{params[:name]} #{params[:asset]} #{params[:format]}"
    @site = Site.find_by(name: params[:name])

    path = "#{params[:asset]}.#{params[:format]}"
    @asset = @site.assets.find_by(path: path)

    render inline: @asset.file.download
  end

  def show
    @site = Site.find_by(name: params[:name])
    @asset = @site.assets.find_by(path: 'index.html')

    html = @asset.file.download
    render inline: html
  end

  def create
    site = Site.create(name: "test#{(Site.last.try(:id) || 0) + 1}")

    params[:site][:files].each do |file|
      next if file.blank?

      if file.headers
        filename = file.headers.match(/filename="(.*)"/)[1]
      else
        filename = nil
      end

      asset = Asset.new(site_id: site.id)
      if filename
        path = filename.split('/')[1..-1].join('/')
        asset.path = path
        asset.file.attach(file)
        asset.save
      end

    end

    redirect_to action: :index
  end

  def destroy
    @site = Site.find_by(name: params[:name])
    @site.destroy

    redirect_to action: :index
  end

end