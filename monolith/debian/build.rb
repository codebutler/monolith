#!/usr/bin/ruby

require 'fileutils'

SOURCES = [
  [ 'mono',                'http://ftp.novell.com/pub/mono/sources/mono/mono-2.6.1.tar.bz2' ],
  [ 'libgdiplus',          'http://ftp.novell.com/pub/mono/sources/libgdiplus/libgdiplus-2.6.tar.bz2' ],
  [ 'xsp',                 'http://ftp.novell.com/pub/mono/sources/xsp/xsp-2.6.tar.bz2' ],
  [ 'gtk-sharp',           'http://ftp.novell.com/pub/mono/sources/gtk-sharp212/gtk-sharp-2.12.9.tar.bz2' ],
  [ 'gnome-sharp',         'http://ftp.novell.com/pub/mono/sources/gnome-sharp2/gnome-sharp-2.24.1.tar.bz2' ],
  [ 'gnome-desktop-sharp', 'http://ftp.novell.com/pub/mono/sources/gnome-desktop-sharp2/gnome-desktop-sharp-2.24.0.tar.bz2' ],
  [ 'ndesk-dbus',          'http://www.ndesk.org/archive/dbus-sharp/ndesk-dbus-0.6.0.tar.gz' ],
  [ 'ndesk-dbus-glib',     'http://www.ndesk.org/archive/dbus-sharp/ndesk-dbus-glib-0.4.1.tar.gz' ],
  [ 'webkit-sharp',        'http://ftp.novell.com/pub/mono/sources/webkit-sharp/webkit-sharp-0.3.tar.bz2' ],
  [ 'mono-addins',         'http://ftp.novell.com/pub/mono/sources/mono-addins/mono-addins-0.4.zip' ],
  [ 'monodevelop',         'http://ftp.novell.com/pub/mono/sources/monodevelop/monodevelop-2.2.tar.bz2' ]
]

def run_command(cmd)
  puts "Running: #{cmd}"
  system("#{cmd}")
  raise 'Command Failed' if $? != 0
end

begin
  run_command('dh_testdir')

  orig = Dir.pwd
  dest = File.join(Dir.pwd, 'debian', 'monolith')

  ENV['PATH'] = File.join(dest, 'opt', 'monolith', 'bin') + ':' + ENV['PATH']
  ENV['PKG_CONFIG_PATH'] = File.join(dest, 'opt', 'monolith', 'lib', 'pkgconfig')

  # Ugh...
  FileUtils.mkdir_p('/tmp')
  File.symlink(File.join(dest, 'opt', 'monolith'), '/tmp/monolith')
    
  SOURCES.each do |name, source|
    puts "-"*80
    puts name
    puts "-"*80
    
    builddir = File.join(orig, 'debian', 'build')
    FileUtils.mkdir_p(builddir)
    Dir.chdir(builddir) 
    
    file = source.split('/').last
    if !File.exists?(file)
      run_command("wget #{source}")
    end
    
    dirname = file.sub(/\.tar\.bz2$/, '').sub(/\.tar\.gz$/, '').sub(/\.zip$/, '')
    
    if !File.directory?(dirname)
      if file =~ /\.tar\.bz2$/
        run_command("tar jxf #{file}")
      elsif file =~ /\.tar\.gz$/
        run_command("tar -zxf #{file}")
      elsif file =~ /\.zip$/
        run_command("unzip #{file}")
      else
        raise 'Unknown file type'
      end
    end
    
    Dir.chdir(dirname)	
    
    run_command("./configure --prefix=/opt/monolith")
    run_command("make")    
    run_command("make install DESTDIR=#{dest}")
    
    Dir.chdir('..')
  end
ensure
  if File.symlink?('/tmp/monolith')
    File.delete('/tmp/monolith')
  end
end
