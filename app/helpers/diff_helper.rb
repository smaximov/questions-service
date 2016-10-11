# frozen_string_literal: true

module DiffHelper
  def render_diff(old, new)
    content_tag(:p, class: 'diff') do
      Diff::LCS.diff(old, new, Diff::LCS::CompactDiffCallbacks.new) do |chunk|
        tag = case chunk.type
              when :removal then :del
              when :addition then :ins
              else :span
              end

        concat content_tag(tag, chunk.to_s)
      end
    end
  end
end
