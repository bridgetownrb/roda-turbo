# frozen_string_literal: true

require "test_helper"

class TestTurbo < Minitest::Test
  def app
    @@app ||= Class.new(Roda) do
      plugin :turbo

      route do |r|
        r.get "turboing" do
          response.turbo_stream

          "Is Turbo? #{r.turbo_stream?}"
        end

        r.post "stream_this" do
          turbo_stream.append "some-id", "<p>Hello World!</p>"
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
end
