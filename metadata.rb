name             "imagemagick-source"
maintainer       "Maxim Chernyak"
maintainer_email "madfancier@gmail.com"
license          "MIT"
description      "Installs/Configures ImageMagick from source"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

supports 'ubuntu'

depends 'build-essential'
depends 'apt'
# depends 'ohai', '>= 1.1.4'
