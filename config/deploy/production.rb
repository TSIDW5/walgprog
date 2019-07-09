set :stage, :production

server '206.189.204.56', roles: %w[app web db], primary: true, user: 'deployer'
set :rails_env, 'production'
