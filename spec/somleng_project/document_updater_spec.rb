require 'spec_helper'
require 'somleng_project/document_updater'

describe SomlengProject::DocumentUpdater do
  describe "#update_all!", :vcr, :cassette => :document_updater_update_all do
    let(:real_time_data_helper) { SomlengProject::SpecHelpers::RealTimeDataHelper.new }

    before do
      setup_scenario
    end

    around do |example|
      with_fakefs { example.run }
    end

    def setup_scenario
      stub_env(env)
      subject.update_all!
    end

    def with_fakefs(&block)
      FakeFS do
        FakeFS::FileSystem.clone(File.expand_path("../../lib/", File.dirname(__FILE__)))
        FakeFS::FileSystem.clone(File.expand_path("../", File.dirname(__FILE__)))
        yield
      end
    end

    def env
      real_time_data_helper.project_env
    end

    def assert_update_all!
      real_time_data_helper.document_assertions.each do |asserted_renderer_class, asserted_content|
        output_path = asserted_renderer_class.constantize.output_path
        expect(File).to exist(output_path)
        content = File.read(output_path)
        asserted_content.each do |content_assertion|
          expect(content).to include(content_assertion)
        end
      end
    end

    it { assert_update_all! }
  end
end
