config.load_autoconfig()

c.aliases = {'q': 'quit', 'w': 'session-save', 'wq': 'quit --save'}

c.url.default_page = 'https://google.com/'
c.url.start_pages = 'https://google.com/'

c.url.searchengines = {'DEFAULT': 'https://google.com/search?q={}',
                       'hoogle': 'https://hoogle.haskell.org/?hoogle={}',
                       'nix': 'https://search.nixos.org/packages?type=packages&query={}',
                       'yt': 'https://www.youtube.com/results?search_query={}'}
# xb to toggle the status bar
config.bind('xb', 'config-cycle statusbar.show always never')

# xt to toggle the tab bar
config.bind('xt', 'config-cycle tabs.show always never')

# xx = xb + xt
config.bind('xx', 'config-cycle statusbar.show always never;; config-cycle tabs.show always never')

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
# Type: List of QtColor, or QtColor
c.colors.completion.fg = ['#7E9CD8', '#DCD7BA', '#DCD7BA']

# Background color of the completion widget for odd rows.
# Type: QssColor
c.colors.completion.odd.bg = '#223249'

# Background color of the completion widget for even rows.
# Type: QssColor
c.colors.completion.even.bg = '#1F1F28'

# Foreground color of completion widget category headers.
# Type: QtColor
c.colors.completion.category.fg = '#727169'

# Background color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.bg = 'qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #000000, stop:1 #223249)'

# Top border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.top = '#49443C'

# Bottom border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.bottom = '#49443C'

# Foreground color of the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.fg = '#C4746E'

# Background color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.bg = '#1F1F28'

# Foreground color of the matched text in the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.match.fg = '#727169'

# Foreground color of the matched text in the completion.
# Type: QtColor
c.colors.completion.match.fg = '#727169'

# Color of the scrollbar handle in the completion view.
# Type: QssColor
c.colors.completion.scrollbar.fg = '#DCD7BA'

# Background color for the download bar.
# Type: QssColor
c.colors.downloads.bar.bg = '#223249'

# Background color for downloads with errors.
# Type: QtColor
c.colors.downloads.error.bg = '#C34043'

# Font color for hints.
# Type: QssColor
c.colors.hints.fg = '#1F1F28'

# Font color for the matched part of hints.
# Type: QtColor
c.colors.hints.match.fg = '#C4746E'

# Background color of an info message.
# Type: QssColor
c.colors.messages.info.bg = '#223249'

# Background color of the statusbar.
# Type: QssColor
c.colors.statusbar.normal.bg = '#223249'

# Foreground color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.fg = '#DCD7BA'

# Background color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.bg = '#76946A'

# Background color of the statusbar in passthrough mode.
# Type: QssColor
c.colors.statusbar.passthrough.bg = '#759CD8'

# Background color of the statusbar in command mode.
# Type: QssColor
c.colors.statusbar.command.bg = '#223249'

c.colors.statusbar.url.fg = '#C4746E'
c.colors.statusbar.url.hover.fg = '#C4746E'
c.colors.statusbar.url.success.http.fg = '#C4746E'
c.colors.statusbar.url.success.https.fg = '#C4746E'
# Foreground color of the URL in the statusbar when there's a warning.
# Type: QssColor
c.colors.statusbar.url.warn.fg = '#DCA561'
c.colors.statusbar.url.error.fg = '#DCA561'

# Background color of the tab bar.
# Type: QssColor
c.colors.tabs.bar.bg = '#1F1F28'

# Background color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.bg = '#223249'

# Background color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.bg = '#223249'

# Background color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.bg = '#223249'

# Background color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.bg = '#223249'

# Background color of pinned unselected odd tabs.
# Type: QtColor
c.colors.tabs.pinned.odd.bg = '#76946A'

# Background color of pinned unselected even tabs.
# Type: QtColor
c.colors.tabs.pinned.even.bg = '#76946A'

# Background color of pinned selected odd tabs.
# Type: QtColor
c.colors.tabs.pinned.selected.odd.bg = '#223249'

# Background color of pinned selected even tabs.
# Type: QtColor
c.colors.tabs.pinned.selected.even.bg = '#223249'

c.fonts.web.size.default = 14

# Default font families to use. Whenever "default_family" is used in a
# font setting, it's replaced with the fonts listed here. If set to an
# empty value, a system-specific monospace default is used.
# Type: List of Font, or Font
c.fonts.default_family = '"Iosevka"'

# Default font size to use. Whenever "default_size" is used in a font
# setting, it's replaced with the size listed here. Valid values are
# either a float value with a "pt" suffix, or an integer value with a
# "px" suffix.
# Type: String
c.fonts.default_size = '14pt'

# Font used in the completion widget.
# Type: Font
c.fonts.completion.entry = '14pt "Iosevka"'

# Font used for the debugging console.
# Type: Font
c.fonts.debug_console = '14pt "Iosevka"'

# Font used for prompts.
# Type: Font
c.fonts.prompts = 'default_size sans-serif'

# Font used in the statusbar.
# Type: Font
c.fonts.statusbar = '14pt "Iosevka"'
