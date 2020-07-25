# Development Information

These are workarounds/required setups to ensure that services work as expected during development.

## Reached maximum file watchers in VSCode and using NPM 

To add this permanently to max size in systemctl run:
```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

This updates it from 8192 (default in Ubuntu) to 524288 maximum files to watch.

To only temporarily update this you can use:
```bash
sudo sysctl fs.inotify.max_user_watches=524288
sudo sysctl -p
```

To view the current total use:
```bash
cat /proc/sys/fs/inotify/max_user_watches
```