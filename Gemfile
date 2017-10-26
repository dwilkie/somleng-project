source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rake"
gem "activesupport"
gem "httparty"
gem "somleng-rtd_client", :github => "somleng/somleng-rtd_client"

group :test do
  gem "rspec"
  gem "pry"
  gem "vcr"
  gem "webmock"
  gem "fakefs"
end
