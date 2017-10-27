require 'active_support/dependencies/autoload'
require 'active_support/number_helper'
require 'active_support/core_ext/array/extract_options'

class IntroductionForDevelopmentOrganizationsRenderer < Dynamizer::Renderer
  TEMPLATE_NAME = "docs/introduction_for_development_organizations.md"

  def self.template_name
    TEMPLATE_NAME
  end

  def last_updated_at
    Date.today.to_time.strftime("%d %B %Y")
  end

  def ews_inbound_calls
    number_to_human(data.ews_data.calls_inbound_count)
  end

  def ews_inbound_minutes
    number_to_human(data.ews_data.calls_inbound_minutes)
  end

  def ews_outbound_calls
    number_to_human(data.ews_data.calls_outbound_count)
  end

  def ews_outbound_minutes
    number_to_human(data.ews_data.calls_outbound_minutes)
  end

  def ews_total_amount_saved
    data.ews_data.total_amount_saved
  end

  def ews_twilio_price_voice_url
    data.ews_project.twilio_price.voice_url
  end

  def avf_twilio_price_voice_url
    data.avf_project.twilio_price.voice_url
  end

  def avf_total_equivalent_twilio_price
    data.avf_data.total_equivalent_twilio_price
  end

  def avf_twilio_price_voice
    data.avf_project.twilio_price.outbound_voice_price.sub(/0{1,}$/, "0")
  end

  def avf_outbound_calls
    number_to_human(data.avf_data.calls_outbound_count)
  end

  def avf_total_amount_saved
    data.avf_data.total_amount_saved
  end

  def avf_outbound_minutes
    number_to_human(data.avf_data.calls_outbound_minutes)
  end

  private

  def number_to_human(*args)
    options = args.extract_options!
    ActiveSupport::NumberHelper.number_to_human(*args, {:units => units}.merge(options))
  end

  def units
    {
      :thousand => "K",
      :million => "M",
      :billion => "B",
      :trillion => "T",
      :quadrillion => "Q"
    }
  end
end
