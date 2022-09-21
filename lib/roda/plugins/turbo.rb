# frozen_string_literal: true

require "turbo/streams/tag_builder"

class Roda
  module RodaPlugins
    module Turbo
      def self.configure(app, opts = OPTS)
        app.opts[:turbo_stream_content_type] = opts[:content_type] || "text/vnd.turbo-stream.html"
      end

      module RequestMethods
        def turbo_stream?
          (env["HTTP_ACCEPT"] || []).include?(roda_class.opts[:turbo_stream_content_type])
        end

        def respond_with_turbo_stream
          response["Content-Type"] = roda_class.opts[:turbo_stream_content_type] if turbo_stream?
        end

        private

        def block_result_body(result)
          if result.is_a?(Array) && response["Content-Type"] == roda_class.opts[:turbo_stream_content_type]
            result.join
          else
            super
          end
        end
      end

      module InstanceMethods
        def turbo_stream
          @turbo_stream ||= begin
            request.respond_with_turbo_stream
            ::Turbo::Streams::TagBuilder.new(self)
          end
        end
      end
    end

    register_plugin :turbo, Turbo
  end
end
