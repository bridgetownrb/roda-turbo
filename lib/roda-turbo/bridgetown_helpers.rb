# frozen_string_literal: true

Bridgetown.initializer :"roda-turbo" do |config|
  require "turbo/streams/tag_builder"

  # Add the Turbo plugin to the Roda app
  config.roda do |app|
    app.plugin :turbo
  end

  # Add a turbo_stream helper to Bridgetown views
  config.builder :RodaTurboBuilder do
    def build
      helper :turbo_stream do
        Turbo::Streams::TagBuilder.new(helpers.view, render_method: :partial)
      end
    end
  end
end
