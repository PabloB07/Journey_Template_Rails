# frozen_string_literal: true

# Template: Journey - for Rails 6 and 7
# Author: Pablo Blanco
# Author URI: https://github.com/PabloB07, imcoding.vercel.app
# Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb / URL
# gem install foreman - to install foreman and run it instead of bin/dev to all process in the background async

require "fileutils"
require "shellwords"

def add_template_repository
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("journey-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/PabloB07/Journey_Template_Rails.git",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{Journey_Template_Rails/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def rails_version
  @rails_version ||= Gem::Version.new(Rails.version) # Tell if Rails version is or equals to 6.1.0 or newer
end

def rails_6_or_newer?
  if Gem::Requirement.new(">= 6.1.0").satisfied_by? rails_version # End of life of ruby on rails 6.0.0 ended in (01 Jun 2023), so instead we can use now 6.1.0 or newer.
    return unless rails_6_or_newer?
    puts "Please use Rails 6.1.0 or newer to create a Journey application".upcase # Tell user to use Rails 6.1.0 or newer
  end
end

def add_gems
  gem "cssbundling-rails"
  gem 'devise'
  gem 'friendly_id'
  gem 'sidekiq'
  gem 'simple_form-tailwind'
  gem 'chilean-rutify'
  gem 'kaminari'
end

def add_users
  # Install Devise

  generate "devise:install"

  # Configure Devise

  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: 'development'

  # Routing homepage as index page

  route "root to: 'home#index'"

  # Create Devise User model

  generate :devise, "User", "first_name:string", "last_name:string"

  insert_into_file "config/routes.rb",
    ", controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }\n\n",
    after: "devise_for :users"

  # Set admin boolean to false by default

  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end
end

# Use default esbuild or Skip Esbuild argument

def default_esbuild
  return if options[:javascript] == "esbuild"
  unless options[:skip_javascript]
    @options = options.merge(javascript: "esbuild")
  end
end

# Adding javascript packages and esbuild-rails dependencies

def add_javascript
  run "yarn add local-time esbuild-rails trix @hotwired/stimulus @hotwired/turbo-rails @rails/activestorage @rails/ujs @rails/request.js chokidar @fortawesome/fontawesome-free lucide-react"
end

# Copying files and assets to the app

def copy_templates
  remove_file "app/assets/stylesheets/application.css"
  remove_file "app/javascript/application.js"
  remove_file "app/javascript/controllers/index.js"
  remove_file "Procfile.dev"

  copy_file "Procfile"
  copy_file "Procfile.dev"
  copy_file ".foreman"
  copy_file "esbuild.config.mjs"
  copy_file "app/javascript/application.js"
  copy_file "app/javascript/controllers/index.js"

  directory "app", force: true
  directory "config", force: true
  directory "lib", force: true
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"

  insert_into_file "config/routes.rb",
    "require 'sidekiq/web'\n\n",
    before: "Rails.application.routes.draw do"

  sidekiq = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY
  insert_into_file "config/routes.rb", "#{sidekiq}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_friendly_id
  generate "friendly_id"
  insert_into_file(Dir["db/migrate/**/*friendly_id_slugs.rb"].first, "[5.2]", after: "ActiveRecord::Migration")
end

def add_kaminari
  generate "kaminari"
end

def add_simple_form
  generate "simple_form:tailwind:install"
end

# Main setup

add_template_repository
add_gems

after_bundle do
  add_users
  add_sidekiq
  copy_templates
  tailwindcss
  default_esbuild
  add_javascript
  add_friendly_id
  add_kaminari
  add_simple_form
  rails_command "active_storage:install"

  # Make sure to bundle lock in Gemfile

  run "bundle lock --add-platform x86_64-linux"

  # Default esbuild config file is esbuild.config.js by default but you can change it to esbuild.config.mjs or esbuild.config.cjs or whatever you want

  default_esbuild

  # Migrate & create

  rails_command "db:create"
  rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit with Journey Template Rails :fire: :package:" }

  # Final message, run your app and say goodbye 💎!

  say
  say "🥳 Project successfully created with Journey! 🧗", :green
  say
  say "Switch to your app with:", :green
  say "  cd #{app_name}", :blue
  say
  say "Execute the follow commands:", :green
  say "  gem install foreman", :blue
  say
  say "Run #{app_name} app with:", :green
  say "  bin/dev", :blue
  say
  say "💎💎💎💎💎💎💎💎💎💎"
  say "💎 ENJOY YOUR JOURNEY 💎", :blue
  say "💎💎💎💎💎💎💎💎💎💎"
  say
end
