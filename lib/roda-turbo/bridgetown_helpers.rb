# frozen_string_literal: true

require "roda-turbo/stream_tag_builder"

Bridgetown.initializer :"roda-turbo" do |config|
  # Add the Turbo plugin to the Roda app
  config.roda do |app|
    app.plugin :turbo
  end

  # Add a turbo_stream helper to Bridgetown views
  config.builder :RodaTurboBuilder do
    def build
      helper :turbo_stream do
        RodaTurbo::StreamTagBuilder.new(helpers.view, render_method: :partial)
      end
    end
  end
end
