# frozen_string_literal: true

require_relative 'chunk'

module Diff
  module LCS
    class CompactDiffCallbacks
      attr_reader :diffs

      def initialize
        @diffs = []
      end

      def match(event)
        same << event.old_element
      end

      def discard_a(event)
        removal << event.old_element
      end

      def discard_b(event)
        addition << event.new_element
      end

      private

      Chunk::TYPES.each do |type|
        define_method(type) { chunk(type) }
      end

      def chunk(type)
        if @chunk.nil? || @chunk.type != type
          @chunk = Chunk.new(type)
          @diffs << @chunk
        end

        @chunk
      end
    end
  end
end
