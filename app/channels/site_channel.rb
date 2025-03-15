class SiteChannel < ApplicationCable::Channel
  def subscribed
    @siteName = params[:siteName]
    @stream = "sites.#{@siteName}"

    stream_from @stream
  end

  def receive(data)
  end

  def unsubscribed
    # Cleanup if needed when unsubscribed
  end
end

