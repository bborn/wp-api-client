require 'webmock/rspec'

RSpec.describe WpApiClient::Configuration do
  describe "#configure" do

    it "can set the endpoint URL for the API connection" do
      VCR.turned_off do

        imaginary_api_location = "http://example.com/wp-json/wp/v2"

        # get an example API response and mock it

        ::WebMock.stub_request(:get,
          imaginary_api_location + "/custom_post_type?_embed=true"
        ).to_return(
          body: example_response,
          headers: {'Content-Type' => 'application/json'}
        )

        # Configure the API client to point somewhere else
        @api.configure do |api_client|
          api_client.endpoint = imaginary_api_location
        end

        @api.get('custom_post_type')
      end
    end

    it "can specify whether or not to request embedded resources" do
      VCR.turned_off do

        @api.configure do |api_client|
          api_client.embed = false
        end

        # get an example API response and mock it
        ::WebMock.stub_request(:get,
          @api.connection.configuration.endpoint + "/posts/1"
        ).to_return(
          body: example_response,
          headers: {'Content-Type' => 'application/json'}
        )

        post = @api.get('posts/1')
      end
    end

    it "can set up OAuth credentials", vcr: {cassette_name: :oauth_test} do
      oauth_credentials = get_test_oauth_credentials

      @api.configure do |api_client|
        api_client.oauth_credentials = oauth_credentials
      end

      @api.get('posts/1')
    end

    it "can set up link relationships", vcr: {cassette_name: :single_post} do
      @api.configure do |api_client|
        api_client.define_mapping("http://my.own/mapping", :post)
      end

      post = @api.get('posts/1')
      expect { post.relations("http://my.own/mapping") }.not_to raise_error
    end

    it "exposes a #proxy configuration option" do
      @api.configure do |api_client|
        api_client.proxy = "http://localhost:8080"
      end

      expect(@api.connection.configuration.proxy).to eq "http://localhost:8080"
    end
  end

private

  def example_response
    YAML.load(File.read WPAPICLIENT_VCR_PATH + '/custom_post_type_collection.yml')['http_interactions'][0]['response']['body']['string']
  end


end
