# frozen_string_literal: true

class PreviewsController < ApplicationController
  before_action :set_preview

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render gotenberg_pdf: {
          display_url: pdf_display_url,
          header_html: pdf_header_html,
          footer_html: pdf_footer_html,
          margin_top: "0.75in",
          margin_bottom: "0.75in",
          margin_left: "0",
          margin_right: "0",
          metadata: {
            Title: @preview[:title],
            Author: "gotenberg-rails-example"
          }
        },
        disposition: :inline,
        filename: "gotenberg-rails-sample.pdf"
      end
    end
  end

  def direct
    html = render_to_string(
      template: "previews/direct",
      layout: false,
      formats: [ :html ]
    )

    pdf = Gotenberg::Rails.render_pdf(
      html:,
      display_url: request.original_url,
      header_html: pdf_header_html,
      footer_html: pdf_footer_html,
      filename: "gotenberg-rails-direct.pdf",
      pdf_options: {
        print_background: true,
        prefer_css_page_size: true,
        margin_top: "0.75in",
        margin_bottom: "0.75in",
        metadata: { Title: "Direct HTML PDF" }
      }
    )

    send_data pdf,
              filename: "gotenberg-rails-direct.pdf",
              type: "application/pdf",
              disposition: :inline
  end

  private

  def pdf_header_html
    render_to_string(template: "previews/pdf_header", layout: false, formats: [ :html ])
  end

  def pdf_footer_html
    render_to_string(template: "previews/pdf_footer", layout: false, formats: [ :html ])
  end

  def pdf_display_url
    base_url = ENV.fetch("PDF_DISPLAY_BASE_URL", request.base_url)

    URI.join("#{base_url.delete_suffix("/")}/", request.fullpath.delete_prefix("/")).to_s
  end

  def set_preview
    @preview = {
      title: "Gotenberg Rails Sample",
      issued_on: Date.current,
      customer: "Example Customer",
      rows: [
        [ "HTML template", "Display the Rails ERB template as a regular page", "OK" ],
        [ "PDF renderer", "Render the same template as a PDF through Gotenberg", "OK" ],
        [ "Header / footer", "Render separate HTML templates on every PDF page", "OK" ],
        [ "Options", "Pass background, page size, and metadata options", "OK" ]
      ]
    }
  end
end
