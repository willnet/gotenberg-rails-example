# Gotenberg Rails Example

This is a minimal Rails application that uses `gotenberg-rails` to render Rails
HTML templates as PDFs through Gotenberg.

## Setup

```sh
docker compose up --build
```

Open <http://localhost:3000> in your browser to view the sample HTML page.

## Try PDF

- HTML: <http://localhost:3000/sample>
- Rails renderer PDF: <http://localhost:3000/sample.pdf>
- Direct API PDF: <http://localhost:3000/direct.pdf>

The `docker-compose.yml` file exposes Gotenberg at `localhost:3001`. You can
change the endpoint used by Rails with `GOTENBERG_ENDPOINT`. In Docker Compose,
Rails uses `http://gotenberg:3000` on the internal Compose network.

```sh
docker compose run --rm -e GOTENBERG_ENDPOINT=http://gotenberg:3000 web bin/rails runner 'puts Gotenberg::Rails.configuration.endpoint'
```

## What This Shows

- Rendering a Rails ERB template as a PDF with `render gotenberg_pdf: ...`
- Rendering an HTML string directly with `Gotenberg::Rails.render_pdf(html: ...)`
- Passing Gotenberg options such as `print_background`, `prefer_css_page_size`,
  and `metadata`

## Test

```sh
docker compose run --rm web bin/rails test
```

## Stop Services

```sh
docker compose down
```
