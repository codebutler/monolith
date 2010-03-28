require 'debian/common'

run_command('dh_testdir')

Dir.chdir(File.join(Dir.pwd, 'sources'))

SOURCES.each do |name, source|
  file = source.split('/').last
  if !File.exists?(file)
    run_command("wget #{source}")
  end
end

