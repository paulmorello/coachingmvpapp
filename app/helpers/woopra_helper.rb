module WoopraHelper

  include WoopraRailsSDK

  def woopra_configure
    woopra = WoopraTracker.new(request)
    woopra.config({
      domain: "proscoutapp.com"
    })
  end

end
