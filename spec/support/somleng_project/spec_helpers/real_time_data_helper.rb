class SomlengProject::SpecHelpers::RealTimeDataHelper
  def project_env
    Hash[project_assertions.map { |project_key, data| [data[:env_var_key], data[:project_id]] }]
  end

  def project_assertions
    @project_assertions ||= {
      :ews => {
        :project_id => "6bb193d9-876e-4846-a42f-8a35db66b477",
        :env_var_key => "EWS_PROJECT_ID"
      },
      :avf => {
        :project_id => "11d41773-cb37-4614-883d-602bb4e1824e",
        :env_var_key =>  "AVF_PROJECT_ID"
      }
    }
  end

  def document_assertions
    @document_assertions ||= {
      "SomlengProject::IntroductionForDevelopmentOrganizationsRenderer" => [
        # EWS data
        "229 K",
        "81.1 K",
        "$8,105.19",
        "https://www.twilio.com/voice/pricing/kh",
        # AVF Data
        "40.5 K",
        "$0.7680 per minute",
        "$31,130.88",
        "https://www.twilio.com/voice/pricing/so"
      ]
    }
  end
end
