# Fail on any command.
set -eux pipefail

# Install Powerline for VIM.
sudo apt install -y python3-pip
# Try to install a distro package first to avoid PEP 668 issues.
if apt-cache show python3-powerline >/dev/null 2>&1; then
	sudo apt install -y python3-powerline
elif apt-cache show powerline >/dev/null 2>&1; then
	sudo apt install -y powerline
else
	# Prefer pipx for installing user-level Python applications in an isolated venv.
	if command -v pipx >/dev/null 2>&1; then
		pipx install powerline-status || pipx upgrade powerline-status || true
	else
		sudo apt install -y pipx python3-venv || true
		# `pipx` may not be on PATH until a new shell, try installing via the module if available.
		if command -v pipx >/dev/null 2>&1; then
			pipx install powerline-status || pipx upgrade powerline-status || true
		else
			# Last resort: attempt user install with pip, allowing break of system packages
			# (PEP 668 may still block; this is explicitly a fallback).
			python3 -m pip install --user --break-system-packages powerline-status || true
		fi
	fi
fi
sudo cp configs/.vimrc ~/.vimrc
sudo apt install -y fonts-powerline

# Install Patched Font
mkdir ~/.fonts
sudo cp -a fonts/. ~/.fonts/
fc-cache -vf ~/.fonts/