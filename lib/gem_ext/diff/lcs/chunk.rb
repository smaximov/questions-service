# frozen_string_literal: true

module Diff
  module LCS
    class Chunk
      TYPES = %i(same removal addition).freeze

      attr_reader :type, :buffer

      def initialize(type)
        @type = type
        @buffer = String.new
      end

      def <<(char)
        @buffer << char
      end

      def to_s
        @buffer
      end
    end
  end
end
