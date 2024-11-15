config.load_autoconfig()

# xb to toggle the status bar
config.bind('xb', 'config-cycle statusbar.show always never')

# xt to toggle the tab bar
config.bind('xt', 'config-cycle tabs.show always never')

# xx = xb + xt
config.bind('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show always never')
