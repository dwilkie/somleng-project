require "erb"
require_relative "../data_wrappers/document_data"

class SomlengProject::ApplicationRenderer
  extend ActiveSupport::DescendantsTracker

  DEFAULT_TEMPLATE_EXTENSION = "erb"
  attr_accessor :content, :document_data

  delegate :template_name,
           :template_extension,
           :template_path,
           :output_path,
           :to => :class

  def initialize(options = {})
    self.content = options[:content]
    self.document_data = options[:document_data]
  end

  def render
    ERB.new(template).result(binding)
  end

  def generate_doc!
    FileUtils.mkdir_p(File.dirname(output_path))
    File.open(output_path, 'w') { |file| file.write(render) }
  end

  def content
    @content ||= {}
  end

  private

  def units
    {
      :thousand => "K",
      :million => "M",
      :billion => "B",
      :trillion => "T",
      :quadrillion => "Q"
    }
  end

  def number_to_human(*args)
    options = args.extract_options!
    ActiveSupport::NumberHelper.number_to_human(*args, {:units => units}.merge(options))
  end

  def template
    @template ||= File.read(template_path)
  end

  def document_data
    @document_data ||= SomlengProject::DocumentData.new
  end

  def self.template_extension
    DEFAULT_TEMPLATE_EXTENSION
  end

  def self.template_name
    self::TEMPLATE_NAME
  end

  def self.output_path
    File.expand_path("../../../docs/#{template_name}", File.dirname(__FILE__))
  end

  def self.template_path
    File.expand_path("../templates/#{template_name}.#{template_extension}", File.dirname(__FILE__))
  end

  def self.render?
    true
  end
end
