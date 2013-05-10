include_recipe 'imagemagick-source::ohai_plugin'
include_recipe 'build-essential'

execute 'apt-get update'
execute 'apt-get -y build-dep imagemagick' do
  not_if do
    `apt-get -s build-dep imagemagick`[/(\d+)\snewly\sinstalled/m, 1].to_i == 0
  end
end

package 'checkinstall'

im_url = node['imagemagick-source']['url']
im_src_basename = ::File.basename(im_url).split('?').first
im_src_dirname = Chef::Config['file_cache_path'] || '/tmp'
im_src_path = "#{im_src_dirname}/#{im_src_basename}"
configure_flags = node['imagemagick-source']['configure_flags'] || []

im_installed = -> do
  ::File.exists?('/usr/local/bin/convert') &&
    ( node.automatic_attrs['imagemagick'] &&
      node.automatic_attrs['imagemagick']['version'] == node['imagemagick-source']['version'] &&
      node.automatic_attrs['imagemagick']['configure_arguments'].sort == configure_flags.sort
    )
end

remote_file im_url do
  source im_url
  path im_src_path
  backup false
  not_if { im_installed.call }
end

bash "compile_imagemagick_source" do
  cwd im_src_dirname
  code <<-EOH
    tar zxf #{im_src_basename} -C #{im_src_dirname} &&
    ls -al; true
    cd #{::File.basename(im_src_basename, '.tar.gz')} &&
    ./configure #{configure_flags.join(' ')} &&
    make && checkinstall
  EOH

  not_if { im_installed.call }
end

execute 'ldconfig /usr/local/lib' do
  not_if { system('ldconfig -p | grep libMagickCore') }
end
