use inc::Module::Install;

name         ('CGI::Kwiki');
version_from ('lib/CGI/Kwiki.pm');
author       ('Brian Ingerson <ingy@cpan.org>');
abstract     ("A Quickie Wiki that's not too Tricky");
license      ('perl');

install_script('kwiki-install');

include_deps   ('Test::More', 5.004);
build_requires ('Test::More', 0);

clean_files('Pages');

&Meta->write;
&Makefile->write;
