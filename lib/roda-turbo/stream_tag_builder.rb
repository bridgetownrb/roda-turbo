# frozen_string_literal: true

module RodaTurbo
  # The tag builder for use in Roda routes and views
  #
  # (Note: most of this code is lifted from the turbo-rails gem: https://github.com/hotwired/turbo-rails)
  class StreamTagBuilder
    def initialize(view_context, render_method: :render)
      @view_context, @render_method = view_context, render_method
    end

    ### HTML Generation

    def turbo_stream_action_tag(action, target: nil, targets: nil, template: nil)
      template = action.to_sym == :remove ? "" : "<template>#{template}</template>"

      safe_if_required = ->(str) do
        str.respond_to?(:html_safe) ? str.html_safe : str
      end

      if target
        safe_if_required.(%(<turbo-stream action="#{action}" target="#{target}">#{template}</turbo-stream>))
      elsif targets
        safe_if_required.(%(<turbo-stream action="#{action}" targets="#{targets}">#{template}</turbo-stream>))
      else
        raise ArgumentError, "target or targets must be supplied"
      end
    end

    ### Actions

    def remove(target)
      action :remove, target
    end

    def remove_all(targets)
      action_all :remove, targets
    end

    def replace(target, content = nil, **rendering, &block)
      action(:replace, target, content, **rendering, &block)
    end

    def replace_all(targets, content = nil, **rendering, &block)
      action_all(:replace, targets, content, **rendering, &block)
    end

    def before(target, content = nil, **rendering, &block)
      action(:before, target, content, **rendering, &block)
    end

    def before_all(targets, content = nil, **rendering, &block)
      action_all(:before, targets, content, **rendering, &block)
    end

    def after(target, content = nil, **rendering, &block)
      action(:after, target, content, **rendering, &block)
    end

    def after_all(targets, content = nil, **rendering, &block)
      action_all(:after, targets, content, **rendering, &block)
    end

    def update(target, content = nil, **rendering, &block)
      action(:update, target, content, **rendering, &block)
    end

    def update_all(targets, content = nil, **rendering, &block)
      action_all(:update, targets, content, **rendering, &block)
    end

    def append(target, content = nil, **rendering, &block)
      action(:append, target, content, **rendering, &block)
    end

    def append_all(targets, content = nil, **rendering, &block)
      action_all(:append, targets, content, **rendering, &block)
    end

    def prepend(target, content = nil, **rendering, &block)
      action(:prepend, target, content, **rendering, &block)
    end

    def prepend_all(targets, content = nil, **rendering, &block)
      action_all(:prepend, targets, content, **rendering, &block)
    end

    ### Base Action

    def action(name, target, content = nil, **rendering, &block)
      template = render_template(target, content, **rendering, &block)

      turbo_stream_action_tag name, target: target, template: template
    end

    def action_all(name, targets, content = nil, **rendering, &block)
      template = render_template(targets, content, **rendering, &block)

      turbo_stream_action_tag name, targets: targets, template: template
    end

    private

    def render_template(_target, content = nil, **rendering, &block)
      if content
        content
      elsif block
        @view_context.capture(&block)
      elsif rendering.any?
        @view_context.send(@render_method, **rendering)
      end
    end
  end
end
