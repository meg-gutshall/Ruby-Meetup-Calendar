task :environment do
  require "rubygems"
  require "bundler"
  require "bundler/setup"

  require "active_support"
  require "active_support/core_ext"

  require "dotenv/load"

  require "./lib/event"
  require "./lib/events"
  require "./lib/groups_sorter"
  require "./lib/posts_generator"
end

namespace :update_data do
  desc "Updates the currently known events & converts them into posts"
  task all: :environment do
    Events::FutureClearer.new.call
    PostsGenerator.new.call
  end

  desc "Sorts the src/_data/groups.yml file by group name"
  task sort: :environment do
    GroupsSorter.new.call
  end
end
