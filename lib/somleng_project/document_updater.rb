Dir[File.expand_path("renderers/**/*.rb", File.dirname(__FILE__))].each { |f| require f }
require_relative "data_wrappers/document_data"

class SomlengProject::DocumentUpdater
  def update_all!
    renderers_to_execute.each do |renderer_class|
      renderer_class.new(:document_data => document_data).generate_doc!
    end
  end

  private

  def document_data
    @document_data ||= SomlengProject::DocumentData.new
  end

  def renderers_to_execute
    SomlengProject::ApplicationRenderer.descendants.select { |renderer_class| renderer_class.render? }
  end
end
