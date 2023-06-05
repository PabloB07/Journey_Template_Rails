# 🧗🏻‍♂️ Journey Template
A Rails 6 & 7 application template for personal use. This particular template utilizes [TailwindCSS](https://tailwindcss.com), a utility-first CSS framework for rapid UI development.

Now we don't need Webpack, we need the new ESBuild!

## 💎 Included gems

- [devise](https://github.com/plataformatec/devise)
- [friendly_id](https://github.com/norman/friendly_id)
- [kaminari]()
- [sidekiq](https://github.com/mperham/sidekiq)
- [lucide-Icons (React)]()
- [chilean-rutify]()
- [simple-form-tailwind]()
- Etc, etc...

## 🍀 Tailwind & ESBuild
With Rails 6 & 7 we have ESBuild by default now. so we can generate fresh

### **WARNING** <> ```For Rails 6, please use version >= 6.1```

# 🔨 How it works

When creating a new rails app simply pass the template file through.

# 👨🏻‍🎨 Creating a new app

```ruby
rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb

```
Or
```ruby
rails new myapp -d <postgresql, mysql, sqlite3> -m "Raw URL"
```

## Finally

```ruby
bin/dev
```

# ✅ Once installed what do I get?

- ESBuild support + Tailwind configured in the `app/javascript` directory.
- Devise with a new `name` field already migrated in. The name field maps to the `first_name` and `last_name` fields in the database.
- Support for Friendly IDs thanks to the handy [friendly_id](https://github.com/norman/friendly_id) gem. Note that you'll still need to do some work inside your models for this to work. This template installs the gem and runs the associated generator.
- Optional Foreman support thanks to a `Procfile`. Once you scaffold the template, run `foreman start` to initalize and head to `locahost:3000` to get `rails server`, `sidekiq` and `bin/dev` running all in one terminal instance. Note: Will still compile down with just `rails server` if you don't want to use Foreman. Foreman needs to be installed as a global gem on your system for this to work. i.e. `gem install foreman`

# More?, yes.

- A custom scaffold view template when generating theme resources (Work in progress).
- Git initialization out of the box
- Custom defaults for button and form elements
- Lucide Icons, for React rails app **NEW**
- Devise login support
- Kaminari
- Chilean Rutify
- ActiveStorage Support

# 🔜 Things to come on this template

- Mrsk
- Faker
- Cancancan
- name_of_person

If you are using this template and you feel good using this template please ⭐️ my Template :)! or you have a question and feel confusing and you want to contribuite please create a Issue.. all contributions are Welcome!

### **Cheers 🤟🏻.**
