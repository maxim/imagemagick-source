require File.expand_path('../support/helpers', __FILE__)

describe 'imagemagick-source::default' do

  include Helpers::ImageMagickSource

  it 'has compiling prerequisites' do
    assert_installed package('build-essential')
    assert_installed package('checkinstall')
  end

  it 'has dependencies' do
    missing_deps_count =
      `apt-get -s build-dep imagemagick`[/(\d+)\snewly\sinstalled/m, 1].to_i

    assert_equal 0, missing_deps_count,
      'Expected 0 missing dependencies for ImageMagick, ' +
        "was #{missing_deps_count}"
  end

  it 'has default download url' do
    refute_nil node['imagemagick-source']['url']
  end

  it 'has libMagickCore in ldconfig cache'  do
    assert system('ldconfig -p | grep libMagickCore')
  end

  it 'has requested version of ImageMagick installed' do
    assert_equal node['imagemagick-source']['version'],
      node.automatic_attrs['imagemagick']['version']
  end

  it 'has requested config flags' do
    assert_equal node['imagemagick-source']['configure_flags'],
      node.automatic_attrs['imagemagick']['configure_arguments']
  end
end
