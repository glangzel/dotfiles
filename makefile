# Do everything.
all: init nixconf link nvim.sh

# Set initial preference.
init:
	.bin/init.sh

# Set up NixOS.
nixconf:
	.bin/nixconf.sh

# Link dotfiles.
link:
	.bin/link.sh

# Set up NeoVim.
nvim:
	.bin/nvim.sh