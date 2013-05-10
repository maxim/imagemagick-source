ohai "reload_imagemagick" do
  action :nothing
  plugin "imagemagick"
end

template "#{node['ohai']['plugin_path']}/imagemagick.rb" do
  source "ohai_imagemagick.rb.erb"
  owner "root"
  group "root"
  mode 00755
  notifies :reload, 'ohai[reload_imagemagick]', :immediately
end

include_recipe "ohai"
