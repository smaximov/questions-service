# frozen_string_literal: true
module HomeHelper
  def tabs
    @selected_tab ||= SelectedTab.new(params[:tab])
  end

  class SelectedTab
    TABS = %i(mine latest unanswered).freeze

    TABS.each do |tab|
      define_method(tab) { tab }
      define_method("#{tab}?") { selected == public_send(tab) }
    end

    attr_reader :selected

    def initialize(tab)
      tab = tab.try(:to_sym)
      @selected = TABS.include?(tab) ? tab : latest
    end
  end
end
