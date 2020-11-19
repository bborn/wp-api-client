RSpec.describe WpApiClient::Relationship do
  describe "relationships with terms", vcr: {cassette_name: 'single_post'} do
    before :each do
      post = @api.get("posts/1")
      @relationship = WpApiClient::Relationship.new(post.resource, "https://api.w.org/term", @api)
    end

    it "presents term objects as a set of key/value collections" do
      relations = @relationship.get_relations
      expect(relations).to be_a Hash
      expect(relations["category"]).to be_a WpApiClient::Collection
    end
  end

  describe "relationships with posts", vcr: {cassette_name: 'single_term'} do
    before :each do
      term = @api.get("categories/1")
      @relationship = WpApiClient::Relationship.new(term.resource, "http://api.w.org/v2/post_type", @api)
    end

    it "returns an collection of posts" do
      relations = @relationship.get_relations
      expect(relations).to be_a Hash
      expect(relations["posts"]).to be_a WpApiClient::Collection
    end
  end

  describe "relationships with featured images", vcr: {cassette_name: 'single_post'} do
    before :each do
      term = @api.get("posts/1")
      @relationship = WpApiClient::Relationship.new(term.resource, "https://api.w.org/featuredmedia", @api)
    end

    it "returns an collection of posts" do
      relations = @relationship.get_relations
      expect(relations).to be_a WpApiClient::Collection
      expect(relations.first).to be_a WpApiClient::Entities::Image
    end
  end

  describe "relationships with metadata", vcr: {cassette_name: 'single_post_auth', record: :new_episodes} do
    before :each do
      # we need oAuth for this
      oauth_credentials = get_test_oauth_credentials
      @api.configure do |api_client|
        api_client.oauth_credentials = oauth_credentials
      end

      post = @api.get("posts/1")
      @relationship = WpApiClient::Relationship.new(post.resource, "https://api.w.org/meta", @api)
    end

    it "returns an hash of meta" do
      relations = @relationship.get_relations
      expect(relations).to be_a Hash
      expect(relations["example_metadata_field"]).to be_a String
    end
  end

end
