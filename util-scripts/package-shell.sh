#!/bin/bash -e

mkdir -p utils/
cp -r redist/shell redist/tmp_shell
cp utils/{dropbearmulti,sftp-server,mdnsd} redist/tmp_shell/tools
chmod +x redist/tmp_shell/special/shell.sh
tar czf redist/shell.tar.gz redist/tmp_shell
rm -rf redist/tmp_shell
