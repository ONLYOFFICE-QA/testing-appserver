# frozen_string_literal: true

module TestingAppServer
  # module for using palladium. It help to init palladium object and set result
  module PalladiumWrapper
    # init palladium object
    # @param [Hash] params is a hash with all necessary data for work with palladium
    # :host is a address to palladium
    # :token - is a api token. Take it from palladium web interface
    # :product - is a name of product. All results wil be added to it. Product will be created if not exist
    # :run - is a name of plan. All results wil be added to it. Run will be created if not exist
    def init_palladium(params = {})
      Palladium.new(host: 'palladium.teamlab.info',
                    token: palladium_token,
                    product: params[:product_name],
                    plan: params[:plan_name],
                    run: params[:suite_name])
    rescue StandardError => e
      OnlyofficeLoggerHelper.log("Cant init palladium. Error: #{e}", 41)
    end

    def palladium_token
      @palladium_token ||= File.read("#{ENV['HOME']}/.palladium/token")
    end
  end
end
