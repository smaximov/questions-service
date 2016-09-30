# frozen_string_literal: true
guard :rspec, cmd: 'bundle exec rspec' do
  watch('spec/spec_helper.rb')                        { 'spec' }
  watch('config/routes.rb')                           { 'spec/features' }
  watch('app/controllers/application_controller.rb')  { 'spec/controllers' }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
    ["spec/routing/#{m[1]}_routing_spec.rb",
     "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
     "spec/acceptance/#{m[1]}_spec.rb"]
  end
  watch(%r{^spec/support/matchers/(.+)\.rb$}) { |m| "spec/matchers/#{m[1]}_spec.rb" }
  watch('config/i18n-tasks.yml') { 'spec/i18n_spec.rb' }
  watch(%r{^config/locales/(.+)\.yml$}) { 'spec/i18n_spec.rb' }
end
