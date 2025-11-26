rm -rf ~/.config/hypr
rm -rf ~/.config/niri
rm -rf ~/.config/nvim
rm -rf ~/.config/kitty
rm -rf ~/.config/tmux
rm -rf ~/.config/waybar
rm -rf ~/.config/fastfetch
rm -rf ~/.config/scripts/logout.sh
rm -rf ~/.config/scripts/wppicker.sh
rm -rf ~/Wallpapers
rm -rf ~/.vimrc
rm -rf ~/.config/Code/User/settings.json
rm -rf ~/.config/Code/User/keybindings.json
rm -rf ~/.config/rofi

cp -r dotfiles/hypr ~/.config/
cp -r dotfiles/niri ~/.config/
cp -r dotfiles/nvim ~/.config/
cp -r dotfiles/kitty ~/.config/
cp -r dotfiles/tmux ~/.config/
cp -r dotfiles/waybar ~/.config/
cp -r dotfiles/fastfetch ~/.config/
cp dotfiles/.vimrc ~/.vimrc
cp dotfiles/settings.json ~/.config/Code/User/
cp dotfiles/keybindings.json ~/.config/Code/User/
cp -r dotfiles/rofi ~/.config/

mkdir -p ~/.config/scripts/
cp scripts/logout.sh ~/.config/scripts/
cp scripts/wppicker.sh ~/.config/scripts/
cp dotfiles/.p10k.zsh ~/

mkdir -p ~/Wallpapers
cp -r wallpapers/Selected/* ~/Wallpapers


