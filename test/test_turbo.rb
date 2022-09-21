# frozen_string_literal: true

require "test_helper"
require "roda-turbo"
require "json"

module CustomActions
  def redirect_to(url, delay: nil)
    action "redirect_to", "", { url: url, delay: delay }.to_json
  end
end

class TestTurbo < Minitest::Test
  def app # rubocop:disable Metrics
    @@app ||= Class.new(Roda) do
      plugin :turbo
      Turbo::Streams::TagBuilder.include CustomActions
      plugin :render, views: File.join(__dir__, "views")

      route do |r|
        r.get "turboing" do
          response.turbo_stream

          "Is Turbo? #{r.turbo_stream?}"
        end

        r.get "in_views" do
          render :in_views
        end

        r.post "stream_this" do
          turbo_stream.append "some-id", "<p>Hello World!</p>"
        end

        r.post "redirect_me" do
          turbo_stream.redirect_to "/url", delay: 1000
        end
      end
    end.app.freeze
  end

  def test_turbo_stream_request
    get "/turboing", {}

    assert_equal "Is Turbo? false", last_response.body
    assert_equal "text/html", last_response.headers["Content-Type"]

    get "/turboing", {}, "HTTP_ACCEPT" => "text/vnd.turbo-stream.html"

    assert_equal "Is Turbo? true", last_response.body
    assert_equal "text/vnd.turbo-stream.html", last_response.headers["Content-Type"]
  end

  def test_turbo_stream_tag
    post "/stream_this", {}

    assert_equal "<turbo-stream action=\"append\" target=\"some-id\"><template><p>Hello World!</p></template></turbo-stream>",
                 last_response.body
  end

  def test_in_views
    get "/in_views", {}

    assert_equal "Tag:\n<turbo-stream action=\"append\" target=\"some-id\"><template><p>I'm in a view!</p></template></turbo-stream>",
                 last_response.body
  end

  def test_custom_actions
    post "/redirect_me", {}

    assert_equal "<turbo-stream action=\"redirect_to\" target=\"\"><template>{\"url\":\"/url\",\"delay\":1000}</template></turbo-stream>",
                 last_response.body
  end
end
