=begin
Template: Journey - Bootstrap 5 - Rails 7
Author: Pablo Blanco
Author URI: https://github.com/PabloB07 (PabloB07 in GitHub), imcoding.live
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb / URL
and finally: foreman start
=end
def add_template_repository
  if __FILE__ =~ %r{\Ahttps?://}
    require "tmpdir"
    source_paths.unshift(tempdir = Dir.mktmpdir("journey-"))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: [
      "--quiet",
      "https://github.com/PabloB07/Journey_Template_Rails7",
      tempdir
    ].map(&:shellescape).join(" ")

    if (branch = __FILE__[%r{Journey_Template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
  else
    source_paths.unshift(File.dirname(__FILE__))
  end
end

def add_gems
  gem 'devise'
  gem 'friendly_id'
  gem 'sidekiq'
  gem 'name_of_person'
  gem 'simple_form-tailwind'
  gem 'kaminari'
  gem 'font-awesome-rails'
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'
  route "root to: 'home#index'"

  # Create Devise User
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

def copy_templates
  directory "app", force: true
end

def bootstrap
  # Installing bootstrap 5
  run "./bin/rails css:install:tailwind"
end

# Importmaps
def importmaps
  run './bin/importmap pin time --download'
  run './bin/config/importmap.rb'
  run './bin/importmap pin @fortawesome/fontawesome-free --download'
  run './bin/config/importmap.rb'
end

def javascript_app
  insert_into_file 'app/javascript/application.js','\n import "@fortawesome/fontawesome-free"'
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

def add_foreman
  copy_file "Procfile"
end

def add_friendly_id
  generate "friendly_id"
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
  add_foreman
  importmaps
  copy_templates
  bootstrap
  javascript_add
  add_friendly_id
  add_kaminari
  add_simple_form

  # Migrate & create

  rails_command "db:create"
  rails_command "db:migrate"

  git :init
  git add: "."
  git commit: %Q{ -m "Initial commit Journey Template Rails 7 :fire: :package:" }

  say
  say "🥳 Project successfully created with this Template! 💎", :green
  say
  say "Switch to your app by running:", :green
  say "$ cd #{app_name}", :yellow
  say
  say "2 Ways to run:", :green
  say "$ rails server -p 3000", :yellow
  say ""
  say "(foreman run web, sidekiq & services)", :green
  say "$ foreman start", :yellow
  end
