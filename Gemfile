source "https://rubygems.org"

ruby "3.4.9"

gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "sassc-rails"
gem "bootstrap", "~> 5.3.3"
gem "pg"
gem "pg_search"
gem "faker"

# authentication, includes bcrypt
gem "sorcery"

gem "validates_email_format_of"

gem "will_paginate"
gem "will_paginate-bootstrap"

# Bunny.net ActiveStorage, includes bunny_storage_client
gem "active_storage_bunny"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false

# Add HTTP asset caching/compression for Puma
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
