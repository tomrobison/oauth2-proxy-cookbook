require 'bundler/setup'

task default: %w(style)

namespace :style do
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:rubocop)

  require 'foodcritic'
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = { fail_tags: ['any'] }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:rubocop']
