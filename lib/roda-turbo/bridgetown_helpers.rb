# frozen_string_literal: true

require "roda-turbo/stream_tag_builder"

module RodaTurbo
  module BridgetownHelpers
    def turbo_stream
      RodaTurbo::StreamTagBuilder.new(view, render_method: :partial)
    end
  end
end

Bridgetown.initializer :"roda-turbo" do |config|
  config.roda do |app|
    app.plugin :turbo
  end

  Bridgetown::RubyTemplateView::Helpers.include RodaTurbo::BridgetownHelpers
end
