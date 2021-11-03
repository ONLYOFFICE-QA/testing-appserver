# frozen_string_literal: true

desc 'Task to upgrade secret config'
task :update_secret_config do
  sh('gpg --batch --yes -c lib/testing_appserver/data/private_data/data.yml')
end

desc 'Decrypt secret config'
task :decrypt_secret_config do
  sh('gpg --decrypt lib/testing_appserver/data/private_data/data.yml.gpg > lib/testing_appserver/data/private_data/data.yml')
end
