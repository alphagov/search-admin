class ApplicationMailer < Mail::Notify::Mailer
  DEFAULT_FROM_EMAIL = "inside-government@digital.cabinet-office.gov.uk".freeze

  def self.default_from_address
    env = GovukPublishingComponents::AppHelpers::Environment.current_acceptance_environment

    Mail::Address.new(DEFAULT_FROM_EMAIL).tap { |addr|
      addr.display_name = if env == "production"
                            "GOV.UK publishing"
                          else
                            "[GOV.UK #{env}] GOV.UK publishing"
                          end
    }.format
  end

  default from: default_from_address

  def template_id
    @template_id ||= ENV.fetch("GOVUK_NOTIFY_TEMPLATE_ID", "fake-test-template-id")
  end
end
