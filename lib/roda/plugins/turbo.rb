# frozen_string_literal: true

require "roda-turbo/stream_tag_builder"

class Roda
  module RodaPlugins
    module Turbo
      def self.load_dependencies(app)
        app.plugin :response_request
      end

      module RequestMethods
        def turbo_stream?
          (env["HTTP_ACCEPT"] || []).include?("text/vnd.turbo-stream.html")
        end
      end

      module ResponseMethods
        def turbo_stream
          self["Content-Type"] = "text/vnd.turbo-stream.html" if request.turbo_stream?
        end
      end

      module InstanceMethods
        def turbo_stream
          @turbo_stream ||= begin
            response.turbo_stream
            RodaTurbo::StreamTagBuilder.new(self)
          end
        end
      end
    end

    register_plugin :turbo, Turbo
  end
end
