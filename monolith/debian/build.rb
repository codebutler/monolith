#!/usr/bin/ruby

require 'fileutils'

require 'debian/common'

begin
  run_command('dh_testdir')

  orig = Dir.pwd
  dest = File.join(Dir.pwd, 'debian', 'monolith')
  sourcesdir = File.join(Dir.pwd, 'sources')

  ENV['PATH'] = File.join(dest, 'opt', 'monolith', 'bin') + ':' + ENV['PATH']
  ENV['PKG_CONFIG_PATH'] = File.join(dest, 'opt', 'monolith', 'lib', 'pkgconfig')

  # Ugh...
  FileUtils.mkdir_p('/tmp')
  File.symlink(File.join(dest, 'opt', 'monolith'), '/tmp/monolith')
    
  builddir = File.join(orig, 'debian', 'build')
  FileUtils.mkdir_p(builddir)
  Dir.chdir(builddir) 
    
  SOURCES.each do |name, source|
    puts "-"*80
    puts name
    puts "-"*80
    
    filename = source.split('/').last

    file = File.join(sourcesdir, filename)
    if !File.exists?(file)
      raise "File not found: #{file}"
    end
    
    dirname = filename.sub(/\.tar\.bz2$/, '').sub(/\.tar\.gz$/, '').sub(/\.zip$/, '')
    
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
