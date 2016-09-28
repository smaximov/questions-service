# frozen_string_literal: true

namespace :i18n do
  desc 'Display I18n health status'
  task :health do
    sh 'bundle exec i18n-tasks health'
  end

  desc 'Find unused translations'
  task :unused do
    sh 'bundle exec i18n-tasks unused'
  end

  desc 'Find missing translations'
  task :missing do
    sh 'bundle exec i18n-tasks missing'
  end
end
