require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Reload code on every request
  config.enable_reloading = true

  # Do not eager load code on boot
  config.eager_load = false

  # Show full error reports
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Caching
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
  end

  config.cache_store = :memory_store

  # Active Storage
  config.active_storage.service = :local

  # --------------------------------------------------
  # MAILER CONFIGURATION (REAL EMAIL VIA GMAIL)
  # --------------------------------------------------

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  # config.action_mailer.smtp_settings = {
  #   address: "smtp.gmail.com",
  #   port: 587,
  #   domain: "gmail.com",
  #   user_name: ENV["GMAIL_USERNAME"],
  #   password: ENV["GMAIL_PASSWORD"],
  #   authentication: "plain",
  #   enable_starttls_auto: true
  # }

  config.action_mailer.default_url_options = {
    host: "192.168.1.20",
    port: 3000
  }

  config.action_controller.default_url_options = {
    host: "192.168.1.20",
    port: 3000
  }

  config.action_mailer.perform_caching = false

  # Allow all hosts in development to make mobile testing easier
  config.hosts.clear


  # --------------------------------------------------

  # Deprecations
  config.active_support.deprecation = :log

  # Raise error if migrations are pending
  config.active_record.migration_error = :page_load

  # Verbose logs
  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true
  config.active_job.verbose_enqueue_logs = true
  config.action_dispatch.verbose_redirect_logs = true

  # Silence asset logs
  config.assets.quiet = true

  # Annotate rendered views with file names
  config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error if before_action references missing actions
  config.action_controller.raise_on_missing_callback_actions = true
end
