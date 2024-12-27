# dotfiles

## Config files

```yaml
.
├── .config/
│   ├── ghostty/
│   │   ├── config
│   │   └── themes/
│   │       ├── custom-dark
│   │       └── custom-light
│   ├── git/
│   │   ├── config
│   │   └── ignore
│   └── nvim/
│       └── init.lua
├── .psqlrc
├── .vimrc
├── .zshenv
└── .zshrc
```

## Instructions

1. Clone the repository

    ```sh
    git clone https://github.com/$USER/dotfiles
    ```

2. Switch to the directory

   ```sh
   cd dotfiles
   ```

3. Place the configuration files in $HOME

    ```sh
    mkdir -p ~/.config/{ghostty,git,nvim}/

    cp -v .config/ghostty/*     ~/.config/ghostty/
    cp -v .config/git/config    ~/.config/git/config
    cp -v .config/git/ignore    ~/.config/git/ignore
    cp -v .config/nvim/init.lua ~/.config/nvim/init.lua
    cp -v .psqlrc               ~/.psqlrc
    cp -v .vimrc                ~/.vimrc
    cp -v .zshenv               ~/.zshenv
    cp -v .zshrc                ~/.zshrc
    ```

4. Install macOS packages

    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew bundle install --file Brewfile
    ```
