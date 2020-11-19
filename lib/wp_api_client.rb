require "ostruct"

require "wp_api_client/version"
require "wp_api_client/configuration"

require "wp_api_client/entities/base"

require "wp_api_client/entities/user"
require "wp_api_client/entities/post"
require "wp_api_client/entities/meta"
require "wp_api_client/entities/taxonomy"
require "wp_api_client/entities/term"
require "wp_api_client/entities/image"
require "wp_api_client/entities/error"
require "wp_api_client/entities/types"

require "wp_api_client/client"
require "wp_api_client/concurrent_client"
require "wp_api_client/connection"
require "wp_api_client/collection"
require "wp_api_client/relationship"

module WpApiClient

  def self.new(&block)
    config = Configuration.new(&block)

    Client.new(Connection.new(config))
  end

  class RelationNotDefined < StandardError; end
  class ErrorResponse < StandardError

    attr_reader :error
    attr_reader :status

    def initialize(json)
      @error = OpenStruct.new(json)
      @status = @error.data["status"]
    end
  end
end
