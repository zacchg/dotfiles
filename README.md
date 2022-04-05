# dotfiles

## Instructions

1. Clone the repository

    ```sh
    git clone https://github.com/GITHUB_USERNAME/dotfiles
    ```

2. Switch to the directory

   ```sh
   cd dotfiles
   ```

3. Link files into place

    ```sh
    ln -s "$(pwd -P)"/.zshrc ~/.zshrc
    ln -s "$(pwd -P)"/.vimrc ~/.vimrc
    ln -s "$(pwd -P)"/.gitconfig ~/.gitconfig
    ln -s "$(pwd -P)"/.gitignore_global ~/.gitignore_global
    ln -s "$(pwd -P)"/.tigrc ~/.tigrc
    ln -s "$(pwd -P)"/.gemrc ~/.gemrc
    ln -s "$(pwd -P)"/.irbrc ~/.irbrc
    ln -s "$(pwd -P)"/.npmrc ~/.npmrc
    ln -s "$(pwd -P)"/.psqlrc ~/.psqlrc
    ```

4. Install MacOS packages

    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    brew bundle install --file Brewfile
    ```

## Files

```yaml
.
├── .gemrc
├── .gitconfig
├── .gitignore_global
├── .irbrc
├── .npmrc
├── .psqlrc
├── .tigrc
├── .vimrc
├── .zshrc
└── Brewfile
```
