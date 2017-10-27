require "somleng/rtd_client"
require "somleng/rtd_client/request/project"

class SomlengData < Dynamizer::Data
  def ews_data
    @ews_data ||= ews_project_request.fetch_real_time_data!
  end

  def avf_data
    @avf_data ||= avf_project_request.fetch_real_time_data!
  end

  def ews_project
    @ews_project ||= ews_project_request.fetch!
  end

  def avf_project
    @avf_project ||= avf_project_request.fetch!
  end

  private

  def ews_project_request
    @ews_project_request ||= build_project_request(self.class.ews_project_id)
  end

  def avf_project_request
   @avf_project_request ||= build_project_request(self.class.avf_project_id)
  end

  def build_project_request(project_id)
    Somleng::RTDClient::Request::Project.new(project_id)
  end

  def self.ews_project_id
    ENV["EWS_PROJECT_ID"]
  end

  def self.avf_project_id
    ENV["AVF_PROJECT_ID"]
  end
end
