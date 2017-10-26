namespace :doc do
  desc "Updates the docs"
  task :update_all do
    require_relative "../somleng_project/document_updater"
    SomlengProject::DocumentUpdater.new.update_all!
  end
end

