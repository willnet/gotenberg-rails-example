# frozen_string_literal: true

Gotenberg::Rails.configure do |config|
  config.endpoint = ENV.fetch("GOTENBERG_ENDPOINT", "http://localhost:3001")
  config.open_timeout = 5
  config.request_timeout = 30
  config.pdf_options = {
    print_background: true,
    prefer_css_page_size: true,
    emulated_media_type: "screen"
  }
end
