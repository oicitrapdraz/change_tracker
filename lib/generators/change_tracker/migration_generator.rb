# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module ChangeTracker
  class MigrationGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_migration(template, extra_options = {})
      migration_dir = File.expand_path('db/migrate')
      if self.class.migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
      else
        migration_template(
          "#{template}.rb.erb",
          "db/migrate/#{template}.rb",
          { migration_version: migration_version }.merge(extra_options)
        )
      end
    end

    def migration_version
      major = ActiveRecord::VERSION::MAJOR

      "[#{major}.#{ActiveRecord::VERSION::MINOR}]" if major >= 5
    end
  end
end
