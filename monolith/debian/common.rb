SOURCES = [
  [ 'mono',                'http://ftp.novell.com/pub/mono/sources/mono/mono-2.6.3.tar.bz2' ],
  [ 'libgdiplus',          'http://ftp.novell.com/pub/mono/sources/libgdiplus/libgdiplus-2.6.2.tar.bz2' ],
  [ 'xsp',                 'http://ftp.novell.com/pub/mono/sources/xsp/xsp-2.6.3.tar.bz2' ],
  [ 'gtk-sharp',           'http://ftp.novell.com/pub/mono/sources/gtk-sharp212/gtk-sharp-2.12.10.tar.bz2' ],
  [ 'gnome-sharp',         'http://ftp.novell.com/pub/mono/sources/gnome-sharp2/gnome-sharp-2.24.1.tar.bz2' ],
  [ 'gnome-desktop-sharp', 'http://ftp.novell.com/pub/mono/sources/gnome-desktop-sharp2/gnome-desktop-sharp-2.24.0.tar.bz2' ],
  [ 'ndesk-dbus',          'http://www.ndesk.org/archive/dbus-sharp/ndesk-dbus-0.6.0.tar.gz' ],
  [ 'ndesk-dbus-glib',     'http://www.ndesk.org/archive/dbus-sharp/ndesk-dbus-glib-0.4.1.tar.gz' ],
  [ 'webkit-sharp',        'http://ftp.novell.com/pub/mono/sources/webkit-sharp/webkit-sharp-0.3.tar.bz2' ],
  [ 'mono-addins',         'http://ftp.novell.com/pub/mono/sources/mono-addins/mono-addins-0.4.zip' ],
  [ 'monodevelop',         'http://ftp.novell.com/pub/mono/sources/monodevelop/monodevelop-2.2.2.tar.bz2' ]
]

def run_command(cmd)
  puts "Running: #{cmd}"
  system("#{cmd}")
  raise 'Command Failed' if $? != 0
end
