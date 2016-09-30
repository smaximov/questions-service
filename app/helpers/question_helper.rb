# frozen_string_literal: true

module QuestionHelper
  WHITELIST_PAGINATION_PARAMS = %i(controller action locale id page).freeze

  # Kaminari generates URLs using all available params. It means that if the
  # previous action was "POST" #create_answer with the answer discarded
  # due to unsuccessful validation, we end up with all attributes from the
  # answer form in the params hash taking part in the URLs generation process.
  #
  # So resulting pagination URLs look like this:
  # /en/questions/62?answer%5Banswer%5D=&authenti...[snipped]...&utf8=%E2%9C%93
  #
  # To work around this issue, we need to pass Kaminari's #paginate helper a hash with
  # all the parameters we don't want to use when generating URLs explicitly set to nil.
  #
  # The #blacklisted_params generates that hash using the whitelist of allowed params.
  def blacklisted_params
    params.keys.each_with_object({}) do |param, hash|
      param = param.to_sym
      hash[param] = nil unless WHITELIST_PAGINATION_PARAMS.include?(param)
    end
  end
end
