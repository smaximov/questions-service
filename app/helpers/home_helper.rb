# frozen_string_literal: true
module HomeHelper
  def tabs
    @selected_tab ||= SelectedTab.new(params[:tab])
  end

  class SelectedTab
    attr_reader :selected

    def initialize(tab)
      @selected = case tab
                  when 'mine' then :mine
                  else :latest
                  end
    end

    def latest?
      @selected == :latest
    end

    def mine?
      @selected == :mine
    end
  end
end
