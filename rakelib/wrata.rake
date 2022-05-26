# frozen_string_literal: true

require 'wrata_api'

namespace(:wrata) do
  # Method checks the launch of the wrata-staging.teamlab.info portal on behalf of the user.
  # @param [String] user_name current portal user
  # @return [True] if everything alright and raise an exception if not
  def ensure_user(user_name)
    api = WrataApi::WrataApi.new
    current_user = api.profile['login']
    return true if current_user == user_name

    raise("You're trying to run wrata tests with #{current_user} instead of #{user_name}")
  end

  desc 'Turn on servers on Wrata'
  task :wrata_turn_on_servers, [:count] do |_, args|
    api = WrataApi::WrataApi.new
    free_pcs = api.free_servers(args[:count])
    free_pcs.power_on('1gb')
    free_pcs.book
  end

  desc 'Add tests to queue'
  task :add_tests_to_queue, [:location, :path] do |_, args|
    location = args[:location] || 'default'
    api = WrataApi::WrataApi.new
    all_files = api.file_list('ONLYOFFICE-QA/testing-appserver')
    test_files = all_files.select { |spec| spec.start_with?(args[:path]) }
    test_files.each do |test|
      api.add_to_queue("~/RubymineProjects/testing-appserver/#{test}",
                       location:,
                       branch: 'master')
    end
  end

  desc 'Run test for appserver'
  task :run_appserver_tests, [:location] do |_, args|
    ensure_user('appserver')
    location = args[:location] || 'default'
    Rake::Task['wrata:wrata_turn_on_servers'].execute(count: 1)
    Rake::Task['wrata:add_tests_to_queue'].execute(location:, path: 'spec/functional_tests')
    puts('One test node is setup. Please check that test are run fine on it')
  end

  desc 'Run test for personal'
  task :run_personal_tests, [:location] do |_, args|
    ensure_user('Personal')
    location = args[:location] || 'default'
    Rake::Task['wrata:wrata_turn_on_servers'].execute(count: 1)
    Rake::Task['wrata:add_tests_to_queue'].execute(location:, path: 'spec/personal')
    puts('One test node is setup. Please check that test are run fine on it')
  end
end
