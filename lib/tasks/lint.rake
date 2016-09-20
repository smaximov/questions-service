# frozen_string_literal: true

begin
  require 'rubocop/rake_task'

  namespace :lint do
    RuboCop::RakeTask.new
  end

  desc 'Run linters'
  task lint: :'lint:rubocop'
rescue LoadError                # rubocop:disable Lint/HandleExceptions
end
