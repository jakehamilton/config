# Taken from https://github.com/LunNova/nixos-configs
# 💖 Thank you!

{ writeShellScriptBin, glib, ... }:
# TODO can this maybe suck less
# https://discourse.nixos.org/t/making-xdg-open-more-resilient/16777
writeShellScriptBin "xdg-open" ''
  # uncomment to get logs somewhere and tail -f it.
  # exec > >(tee -i ~/xdg-open-portal-log.txt)
  # exec 2>&1

  targetFile=$1

  >&2 echo "xdg-open workaround: using org.freedesktop.portal to open $targetFile"

  openFile=OpenFile
  # https://github.com/flatpak/xdg-desktop-portal/issues/683
  # if [ -d "$targetFile" ]; then
  #   openFile=OpenDirectory
  # fi

  if [ -e "$targetFile" ]; then
    exec 3< "$targetFile"
    ${glib}/bin/gdbus call --session \
      --dest org.freedesktop.portal.Desktop \
      --object-path /org/freedesktop/portal/desktop \
      --method org.freedesktop.portal.OpenURI.$openFile \
      --timeout 5 \
      "" "3" {}
  else
    if ! echo "$targetFile" | grep -q '://'; then
      targetFile="https://$targetFile"
    fi

    ${glib}/bin/gdbus call --session \
      --dest org.freedesktop.portal.Desktop \
      --object-path /org/freedesktop/portal/desktop \
      --method org.freedesktop.portal.OpenURI.OpenURI \
      --timeout 5 \
      "" "$targetFile" {}
  fi
''
