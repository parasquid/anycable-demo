set :stage, :vagrant
set :rails_env, "vagrant"

vagrant_ssh_config = `vagrant ssh-config`
  .split("\n")
  .map(&:strip)
  .reduce({}) do |memo, string|
  key, value = string
    .split(/\s/, 2)
    .map(&:strip)
  memo[key] = value
  memo
end

server vagrant_ssh_config["HostName"],
  roles: %w{web app db},
  primary: true,
  user: vagrant_ssh_config["User"],
  port: vagrant_ssh_config["Port"],
  ssh_options: {
    keys: [vagrant_ssh_config["IdentityFile"]],
    forward_agent: vagrant_ssh_config["ForwardAgent"] == "yes",
  }
