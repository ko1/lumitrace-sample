# lumitrace-sample

A small Rails app used to try out the [lumitrace](https://github.com/ko1/lumitrace)
GitHub Action on a realistic project.

The interesting bit is `app/models/cart.rb` — a plain-Ruby domain model with
branches and varied value types (integers, floats, booleans, arrays) — and its
test in `test/models/cart_test.rb`. On a pull request that touches the cart, the
lumitrace action traces the changed lines while `bin/rails test` runs and posts a
GitHub Check showing the recorded values and coverage of the diff.

## How the action is wired in

See `.github/workflows/test.yml`. The integration is just two steps bracketing
the existing `bin/rails test` step, plus a `permissions:` block — the test
command itself is unchanged:

```yaml
- uses: ko1/lumitrace-action/setup@v1
  with:
    collect-mode: last
- run: bin/rails test
- uses: ko1/lumitrace-action/report@v1
  if: always()
```

## Try it

```sh
bin/rails db:test:prepare
bin/rails test
```

Then open a PR that edits `app/models/cart.rb` (e.g. tweak `discount_rate`) and
watch the lumitrace check report the values flowing through the changed lines.
