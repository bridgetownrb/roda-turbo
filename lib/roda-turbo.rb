if defined?(Bridgetown::RubyTemplateView)
  Bridgetown::RubyTemplateView::Helpers.class_eval do
    def turbo_stream
      RodaTurbo::StreamTagBuilder.new(self, :partial)
    end
  end
end
