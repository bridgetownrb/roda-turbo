# frozen_string_literal: true

module Turbo
  module Streams
    module ActionHelper
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
    end
  end
end

# NOTE: this is a slightly modified version of what's available in turbo-rails.
# URL: https://github.com/hotwired/turbo-rails
# We will endeavor to keep this version in-sync with upstream changes.
class Turbo::Streams::TagBuilder
  include Turbo::Streams::ActionHelper

  # @param view_context [Object] the context in which templates are rendered
  # @param render_method [Symbol] the method name to use when rendering a partial
  def initialize(view_context, render_method: :render)
    @view_context, @render_method = view_context, render_method
  end

  def remove(target)
    action :remove, target, allow_inferred_rendering: false
  end

  def remove_all(targets)
    action_all :remove, targets, allow_inferred_rendering: false
  end

  def replace(target, content = nil, **rendering, &block)
    action :replace, target, content, **rendering, &block
  end

  def replace_all(targets, content = nil, **rendering, &block)
    action_all :replace, targets, content, **rendering, &block
  end

  def before(target, content = nil, **rendering, &block)
    action :before, target, content, **rendering, &block
  end

  def before_all(targets, content = nil, **rendering, &block)
    action_all :before, targets, content, **rendering, &block
  end

  def after(target, content = nil, **rendering, &block)
    action :after, target, content, **rendering, &block
  end

  def after_all(targets, content = nil, **rendering, &block)
    action_all :after, targets, content, **rendering, &block
  end

  def update(target, content = nil, **rendering, &block)
    action :update, target, content, **rendering, &block
  end

  def update_all(targets, content = nil, **rendering, &block)
    action_all :update, targets, content, **rendering, &block
  end

  def append(target, content = nil, **rendering, &block)
    action :append, target, content, **rendering, &block
  end

  def append_all(targets, content = nil, **rendering, &block)
    action_all :append, targets, content, **rendering, &block
  end

  def prepend(target, content = nil, **rendering, &block)
    action :prepend, target, content, **rendering, &block
  end

  def prepend_all(targets, content = nil, **rendering, &block)
    action_all :prepend, targets, content, **rendering, &block
  end

  def action(name, target, content = nil, allow_inferred_rendering: true, **rendering, &block)
    template = render_template(target, content, allow_inferred_rendering: allow_inferred_rendering, **rendering, &block)

    turbo_stream_action_tag name, target: target, template: template
  end

  def action_all(name, targets, content = nil, allow_inferred_rendering: true, **rendering, &block)
    template = render_template(
      targets, content, allow_inferred_rendering: allow_inferred_rendering, **rendering, &block
    )

    turbo_stream_action_tag name, targets: targets, template: template
  end

  private

  def render_template(target, content = nil, allow_inferred_rendering: true, **rendering, &block)
    case
    when content
      allow_inferred_rendering ? (render_record(content) || content) : content
    when block_given?
      @view_context.capture(&block)
    when rendering.any?
      @view_context.send(@render_method, **rendering)
    else
      render_record(target) if allow_inferred_rendering
    end
  end

  def render_record(possible_record)
    return unless possible_record.respond_to?(:to_partial_path)

    record_path = possible_record.to_partial_path
    @view_context.send(@render_method, template: record_path)
  end
end
