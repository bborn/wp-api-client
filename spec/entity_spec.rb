RSpec.describe WpApiClient::Entities::Base do
  describe "general entity methods", vcr: {cassette_name: 'single_post', match_requests_on: [:host, :path], record: :new_episodes} do

    it "work to retrieve embedded hypermedia" do
      @api.configure { |api_client| api_client.embed = true }

      # Posts offer terms as embedded hypermedia
      @post = @api.get('posts/1')
      expect(@post.terms("category")).to be_a WpApiClient::Collection
    end

    it "work to retrieve non-embedded hypermedia" do
      @api.configure { |api_client| 
        api_client.embed = false 
        api_client.debug = true
      }

      # Posts offer terms as embedded hypermedia
      @post = @api.get('posts/1')
      expect(@post.terms("category")).to be_a WpApiClient::Collection
    end

    it "allows querying on specific relations from posts to terms" do
      @post = @api.get('posts/1')
      category = @post.terms("category")

      expect(category).to be_a WpApiClient::Collection
    end

    it "allows querying on specific relations from terms to posts" do
      category = @api.get('categories/1')

      expect(category.posts("posts")).to be_a WpApiClient::Collection
    end

  end
end
