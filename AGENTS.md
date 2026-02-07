# AI Agent Playbook

Rules any code-generation agent must follow when editing this repository.
Keep changes minimal, validated, and consistent with existing patterns.

## How to work in this repo

- Prefer surgical edits. Don’t reformat unrelated code. Preserve public APIs unless required.
- Source of truth is the code: read actual files, signatures, and call sites before changing anything.
- Think before acting: understand root causes; don’t treat symptoms.

### Stack constraints (do not drift)

- Ruby 3.4 + Rails 8.1
- No-build frontend: Importmap + tailwindcss-rails (Tailwind v4)
- Use `bin/dev` for local dev (Rails + Tailwind watcher + GoodJob)
- Do not introduce Node/Yarn or JS bundlers

### Commands (run before finishing)

- Tests: `bundle exec rails test` (all) or targeted files
- System tests: `bundle exec rails test:system`
- Coverage: `COVERAGE=1 bundle exec rails test`
- Lint: `bin/rubocop`
- ERB lint: `bundle exec erb_lint --lint-all`
- Assets: `RAILS_ENV=production bin/rails assets:precompile`
- Data: `bin/rails data:plans:seed`

## Boundaries

### Always

- Keep diffs surgical; don’t shuffle files or reformat unrelated code.
- Add/update minimal tests when behavior changes.
- Use i18n keys for user-facing copy (no hardcoded UI strings).
- Keep WebMock enabled in tests; do not allow live HTTP.

### Ask first (high-risk)

- New dependencies (gems / JS packages / tooling).
- Database migrations or schema changes.
- Changes to provider contracts, auth/authorization, billing, or security boundaries.
- Editing Rails credentials / secrets handling.

### Never

- Commit secrets/credentials, master keys, or decrypted values.
- Add Node/Yarn/bundlers to the stack.
- Add debug prints/breakpoints in app/runtime code (`puts`, `pp`, `binding.pry`).
  - Exception: intentional CLI output in Rake tasks is acceptable.

## Git commits

- Use Conventional Commits.
- Subject line ≤ 80 chars, imperative, no trailing period.
- Body (when non-trivial): explain **why** and **how** (not what).
- Types: `feat`, `fix`, `refactor`, `chore`, `test`, `docs`.

## Project map (what goes where)

- `app/`: Rails MVC, jobs, services (legacy), views.
- `lib/`: External providers and infra (`lib/providers`, `lib/faraday`, `lib/rack`).
  - Data in `lib/data/` (e.g., `plans.yml`). Rake tasks in `lib/tasks/`.
- `lib/providers`: Provider interfaces/results + implementations. Use `Providers::Page`/`Providers::Review` at boundaries.
  - Webhook resources via `Providers::Resources` (`:page`, `:review`).
- `test/`: Minitest (`integration/`, `system/`, etc.)
  - VCR cassettes: `test/support/cassettes/`
  - Webhook captures: `test/support/webhook_captures/`
- Controllers: root under `app/controllers/`; namespaced in matching folders.
  - Base classes: `PublicBaseController`, `DashboardBaseController`, `Admin::BaseController`.

## Decision trees (use these defaults)

### 1) You’re touching an Actor/service object

- Is the change trivial (typo, small conditional, tiny refactor)?
  - Yes → keep the existing Actor/service shape.
  - No → convert the touched service to a PORO as part of the change.
- When converting:
  - Prefer explicit constructors + methods (`ThingCreator.new(...).create`)
  - Or move behavior onto the relevant model when it naturally belongs there.

### 2) You’re touching a ViewComponent / adding shared UI

- Are you adding new UI/shared UI?
  - Yes → use Rails partials under `app/views/shared/` (layout-aware; see below).
- Are you touching an existing ViewComponent?
  - Small change → keep it as-is.
  - Meaningful change → prefer migrating it to a partial as part of the change.

## Rails conventions

- Routing: keep routes simple and close to Rails defaults.
  - Avoid redundant `defaults:` / `controller:` overrides when convention can solve it.
  - Avoid `:as` overrides unless strictly necessary.
  - Prefer `namespace` + `resources`.
  - Prefer REST/CRUD: introduce a resource instead of custom actions.

## Code style (scoped, Fizzy-inspired)

Directional rules. Apply them to **new code** and **methods/files you already touch**.
Do not do churn-only refactors solely to “match style”.

- Prefer expanded conditionals over guard clauses.
  - Exception: early return at the very start of a method when the main body is non-trivial.
- Method ordering in classes:
  1) class methods
  2) public methods (with `initialize` first)
  3) private methods
- Order methods vertically by invocation order (top-down flow).
- Only use `!` when there is a corresponding non-`!` method.
- No blank line after visibility modifiers; indent methods under them.
- Thin controllers invoking rich domain APIs; avoid introducing “service artifacts” as glue.
- Jobs should be shallow: enqueue via `*_later`, execute logic in `*_now` / domain methods.

## Fail fast (avoid defensive programming)

We prefer code to break loudly when something unexpected happens.

- Avoid “defensive” checks that mask errors:
  - `respond_to?`, `try`, dynamic `send` to avoid using the real API
  - broad `rescue` that swallows exceptions
  - returning nil/false as a fallback for unexpected states
- Prefer explicit contracts:
  - `find_by!` instead of `find_by` when it must exist
  - `Hash#fetch` when a key must exist
- Rescue only specific exceptions you truly handle, and keep handling intentional.

## Architecture direction

### Services (Actor gem) → POROs

- Current state: there are service objects using the Actor gem.
- Direction: migrate toward POROs inline with Rails/DHH style.
- Do not add new Actor-based services.
- Use the decision tree above to decide when to migrate.

### Views: ViewComponents → Partials

- Do not add new ViewComponents.
- Prefer Rails partials under `app/views/shared/`.
- Because we have 3 layouts (`public`, `application`, `admin`), prefer layout-aware shared folders:
  - `app/views/shared/public/…`
  - `app/views/shared/application/…`
  - `app/views/shared/admin/…`
- Pass data via `locals`; avoid relying on instance vars in shared partials.

## Coding standards & optimization

- Less is more: prefer less code without sacrificing readability.
- Use clear, intention-revealing names; avoid vague names like `Manager`, `Handler`.
- Performance:
  - Avoid N+1 (`includes`, `preload`).
  - Use DB constraints/indexes for new query patterns.
  - Batch processing for large datasets (`find_each`, `insert_all`).
- Dependencies:
  - Do not add new dependencies for trivial tasks.
  - Prefer stdlib / Rails built-ins already in the stack.

## UI & Frontend

- Tailwind v4 tokens live in `app/assets/tailwind/application.css`; use theme variables and brand classes.
- Forms baseline: “Labels on left” layout.
- Stimulus-first:
  - Prefer controllers from `tailwindcss-stimulus-components` and `@stimulus-components/*`.
  - New controllers must be generic, reusable, under `app/javascript/controllers/`, and registered in `controllers/index.js`.
- Copy must follow `docs/brand.md`. Marketing pages must follow `docs/marketing/style-guide.md`.
- No inline styles (`style="..."`). Use Tailwind utilities.
- Prefer semantic HTML and accessibility basics (labels, autocomplete where appropriate).

## Mailers

- Mailer views live under `app/views/mailers/`.
- Shared layout: `app/views/layouts/mailer.html.erb`
- Prefer partials under `app/views/mailers/` for shared sections.
- Use `premailer-rails` to inline styles.
- Set `deliver_later_queue_name` to `:latency_5m` in mailers.

## Testing (must follow)

### What tests should do

- Tests must cover application behavior, not framework behavior.
- Tests must validate observable outcomes (rendered content, redirects, DB changes, enqueued jobs, outbound payloads).
- Avoid:
  - tautological tests (re-implementing method logic in the test)
  - “Rails works” tests
  - status-only assertions with no behavioral check
  - heavy stubbing that can’t catch regressions

### Practical rules

- Framework: Minitest. Fixtures only (factories have been removed). Do not add factories.
- Anatomy: setup (optional); exercise; assertions; cleanup (optional). Leave an empty line between sections.
- Controller/system tests must assert status/redirect AND content (selectors/text) or side effects.
- System tests: use `data-test-id` selectors; add `data-test-id` attributes in views when needed.
- Keep review pages small in tests (~10) for speed and deterministic assertions.

### HTTP / VCR / webhooks

- WebMock enabled.
- Outgoing API calls: recorded with VCR (see Project map for cassette location).
  - VCR structure mirrors provider/API path segments.
  - Filename: `{platform}_{resource}[optional_suffix].yml`.
- Incoming webhooks: do not VCR. Use JSON captures (see Project map).

Canonical pattern (webhook fixture ingestion):

```ruby
test "DataForSEO resolve with async mode" do
  VCR.use_cassette("dataforseo/serp_google_maps_task_post/google_maps_page_resolve") do
    result = Providers::Dataforseo::GoogleMaps::Page.new(
      mode: :async,
      recording: VCR.current_cassette.recording?,
      platform: :google_maps
    ).submit(
      place_eid: @page.place_eid,
      business_name: @location.name,
      country: "GB"
    )

    assert_equal :scheduled, result.status

    ExternalTask.create!(
      record_uuid: @page.uuid,
      record_type: @page.class.name,
      provider: Providers::External::DATAFORSEO,
      resource: Providers::Resources::PAGE,
      eid: result.eid
    )

    payload = WebhookCapture.read(
      provider: Providers::External::DATAFORSEO,
      platform: :google_maps,
      resource: Providers::Resources::PAGE,
      task_eid: result.eid
    )
    assert_not_nil payload

    response = Providers::Dataforseo::GoogleMaps::Page.new(
      mode: :async,
      platform: :google_maps
    ).ingest(payload)

    assert_equal :ok, response.status
    assert_equal "ChIJrVtdwkDzdkgRHgNW25ELRtQ", response.data.place_eid
  end
end
