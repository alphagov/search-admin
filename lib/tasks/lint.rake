desc "Run govuk-lint with similar params to CI"
task "lint" do
  sh "bundle exec govuk-lint-ruby --format clang"
end

task default: :lint
