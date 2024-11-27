# dotfiles

## Config files

```yaml
.
├── .config/
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
    mkdir -p ~/.config/{git,nvim}/
    cp -v "$(pwd -P)"/.config/git/*  ~/.config/git/
    cp -v "$(pwd -P)"/.config/nvim/* ~/.config/nvim/
    cp -v "$(pwd -P)"/.psqlrc        ~/.psqlrc
    cp -v "$(pwd -P)"/.vimrc         ~/.vimrc
    cp -v "$(pwd -P)"/.zshenv        ~/.zshenv
    cp -v "$(pwd -P)"/.zshrc         ~/.zshrc
    ```

4. Install macOS packages

    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew bundle install --file Brewfile
    ```
