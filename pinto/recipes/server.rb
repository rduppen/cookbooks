template "#{node.pinto.bootstrap.home}/bin/pintod.psgi" do
    owner node.pinto.bootstrap.user
    group node.pinto.bootstrap.group
    source 'pintod.psgi.erb'
    variables :repo_root => node.pinto.server.repo_root
    mode '755'
end

template '/etc/init.d/pintod' do
    owner node.pinto.bootstrap.user
    group node.pinto.bootstrap.group
    source 'init.erb'
    variables({ 
        :home => node.pinto.bootstrap.home,
        :workers => node.pinto.server.workers,
        :host => node.pinto.server.host,
        :port => node.pinto.server.port,
        :user => node.pinto.bootstrap.user,
        :group => node.pinto.bootstrap.group
    })
    mode '755'
end


log 'init pinto repo'

bash "source #{node[:pinto][:bootstrap][:home]}/etc/bashrc && pinto -r #{node.pinto.server.repo_root} init" do
    user node[:pinto][:bootstrap][:user]
    group node[:pinto][:bootstrap][:group]
end

service 'pintod' do
    action :restart
end


service 'pintod' do
    action :enable
end
