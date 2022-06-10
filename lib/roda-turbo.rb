# frozen_string_literal: true

if defined?(Bridgetown::RubyTemplateView)
  require "roda-turbo/stream_tag_builder"

  Bridgetown::RubyTemplateView::Helpers.class_eval do
    def turbo_stream
      RodaTurbo::StreamTagBuilder.new(view, render_method: :partial)
    end
  end
end
