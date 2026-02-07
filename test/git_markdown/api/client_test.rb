# frozen_string_literal: true

require "test_helper"

class ApiClientTest < Minitest::Test
  def test_get_makes_http_request
    stub_request(:get, "https://api.github.com/test")
      .with(headers: {"Authorization" => "Bearer test_token"})
      .to_return(status: 200, body: '{"success": true}')

    client = GitMarkdown::Api::Client.new(
      base_url: "https://api.github.com",
      token: "test_token"
    )

    response = client.get("/test")

    assert response.success?
    assert_equal true, response.data["success"]
  end

  def test_get_includes_query_params
    stub_request(:get, "https://api.github.com/test?page=1&per_page=100")
      .to_return(status: 200, body: "[]")

    client = GitMarkdown::Api::Client.new(
      base_url: "https://api.github.com",
      token: "test_token"
    )

    response = client.get("/test", page: 1, per_page: 100)

    assert response.success?
  end

  def test_get_handles_not_found
    stub_request(:get, "https://api.github.com/not-found")
      .to_return(status: 404, body: '{"message": "Not Found"}')

    client = GitMarkdown::Api::Client.new(
      base_url: "https://api.github.com",
      token: "test_token"
    )

    response = client.get("/not-found")

    assert response.not_found?
    refute response.success?
  end

  def test_get_handles_unauthorized
    stub_request(:get, "https://api.github.com/private")
      .to_return(status: 401, body: '{"message": "Bad credentials"}')

    client = GitMarkdown::Api::Client.new(
      base_url: "https://api.github.com",
      token: "invalid_token"
    )

    response = client.get("/private")

    assert response.unauthorized?
    refute response.success?
  end

  def test_get_includes_user_agent
    stub_request(:get, "https://api.github.com/test")
      .with(headers: {"User-Agent" => /git-markdown/})
      .to_return(status: 200, body: "{}")

    client = GitMarkdown::Api::Client.new(
      base_url: "https://api.github.com",
      token: "test_token"
    )

    client.get("/test")
  end
end
