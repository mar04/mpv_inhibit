# mpv_inhibit
mpv plugin that inhibits lockscreen on linux using [freedesktop dbus interface](https://people.freedesktop.org/~hadess/idle-inhibition-spec/re01.html).

It requires [lgi](https://github.com/lgi-devs/lgi), for Arch Linux mpv package built with luajit, it's [this](https://aur.archlinux.org/packages/luajit-lgi) AUR package.

Why? Because of kwin [bug](https://bugs.kde.org/show_bug.cgi?id=495375), inhibition doesn't work out of the box when video output is set to `dmabuf-wayland`.
