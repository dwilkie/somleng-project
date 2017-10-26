require_relative "application_renderer"

class SomlengProject::IntroductionForDevelopmentOrganizationsRenderer < SomlengProject::ApplicationRenderer
  TEMPLATE_NAME = "introduction_for_development_organizations.md"

  def last_updated_at
    Date.today.to_time.strftime("%d %B %Y")
  end

  def ews_inbound_calls
    number_to_human(document_data.ews_data.calls_inbound_count)
  end

  def ews_inbound_minutes
    number_to_human(document_data.ews_data.calls_inbound_minutes)
  end

  def ews_outbound_calls
    number_to_human(document_data.ews_data.calls_outbound_count)
  end

  def ews_outbound_minutes
    number_to_human(document_data.ews_data.calls_outbound_minutes)
  end

  def ews_total_amount_saved
    document_data.ews_data.total_amount_saved
  end

  def ews_twilio_price_voice_url
    document_data.ews_project.twilio_price.voice_url
  end

  def avf_twilio_price_voice_url
    document_data.avf_project.twilio_price.voice_url
  end

  def avf_total_equivalent_twilio_price
    document_data.avf_data.total_equivalent_twilio_price
  end

  def avf_twilio_price_voice
    document_data.avf_project.twilio_price.outbound_voice_price.sub(/0{1,}$/, "0")
  end

  def avf_outbound_calls
    number_to_human(document_data.avf_data.calls_outbound_count)
  end

  def avf_total_amount_saved
    document_data.avf_data.total_amount_saved
  end

  def avf_outbound_minutes
    number_to_human(document_data.avf_data.calls_outbound_minutes)
  end
end
