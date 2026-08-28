# frozen_string_literal: true

require "test_helper"

class PreviewsControllerTest < ActionDispatch::IntegrationTest
  test "shows the sample html" do
    get sample_url

    assert_response :success
    assert_select "h1", "Gotenberg Rails Sample"
    assert_select "a[href='#{sample_path(format: :pdf)}']", "PDF"
  end

  test "renders sample pdf with a display url reachable from gotenberg" do
    original_client = Gotenberg::Rails.client
    original_display_base_url = ENV["PDF_DISPLAY_BASE_URL"]
    fake_client = Object.new
    captured = {}
    fake_client.define_singleton_method(:render_pdf) do |**kwargs|
      captured.merge!(kwargs)
      "%PDF-1.7 sample"
    end

    Gotenberg::Rails.client = fake_client
    ENV["PDF_DISPLAY_BASE_URL"] = "http://web:3000"
    begin
      get sample_url(format: :pdf)
    ensure
      Gotenberg::Rails.client = original_client
      ENV["PDF_DISPLAY_BASE_URL"] = original_display_base_url
    end

    assert_response :success
    assert_equal "application/pdf", response.media_type
    assert_includes captured[:html], 'href="http://web:3000/assets/'
    assert_includes captured[:header_html], "gotenberg-rails example"
    assert_includes captured[:footer_html], 'class="pageNumber"'
    assert_equal "0.75in", captured.dig(:pdf_options, :margin_top)
    assert_equal "0.75in", captured.dig(:pdf_options, :margin_bottom)
  end

  test "renders direct pdf through gotenberg rails" do
    original_client = Gotenberg::Rails.client
    captured = {}
    fake_client = Object.new
    fake_client.define_singleton_method(:render_pdf) do |**kwargs|
      captured.merge!(kwargs)
      "%PDF-1.7 sample"
    end

    Gotenberg::Rails.client = fake_client
    begin
      get direct_url(format: :pdf)
    ensure
      Gotenberg::Rails.client = original_client
    end

    assert_response :success
    assert_equal "application/pdf", response.media_type
    assert_includes response.body, "%PDF-1.7"
    assert_includes captured[:header_html], "Gotenberg Rails Sample"
    assert_includes captured[:footer_html], 'class="totalPages"'
    assert_equal "0.75in", captured.dig(:pdf_options, :margin_top)
  end
end
