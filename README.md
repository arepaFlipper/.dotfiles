# Dotfiles Repository

This repository contains my personal dotfiles, configuration files, and scripts that I use to customize and 
enhance my development environment. Dotfiles are configuration files used to personalize and configure 
various applications and tools in a Unix-like operating system.

### Getting Started

To set up these dotfiles on a new system, follow these steps:

1. Clone the Repository:

```bash
git clone https://github.com/tovar/dotfiles.git
```

2. Navigate to the Dotfiles Directory:
```bash
cd ~/.dotfiles
```

3. Install Stow:
Ensure that Stow is installed on your system. If it's not already installed, you can install it using `pacman`:

```bash
sudo pacman -S stow
```

Run Stow for Desired Configurations:
Use Stow to create symbolic links for the configurations you want. For example, to set up the Bash configuration:

```bash
stow bash
```

    Repeat this step for each configuration you want to apply.

### Directory Structure

The dotfiles are organized into different directories based on the application or tool
they configure. Here's an overview of the directory structure:

- `bash/`: Configuration files for the Bash shell.
- `git/`: Git configuration files.
- `vim/`: Vim configuration files.
- `scripts/`: Custom scripts for various tasks.
- `etc/`: Additional configuration files for various applications.

### Customization
Feel free to customize any of the configuration files to suit your preferences. Stow makes it easy to manage symbolic links, and you can add or modify settings in the existing files or create new ones as needed.

### Dependencies
Make sure to review the dependencies listed in each configuration file. Some configurations may require specific tools or software to be installed on your system.

### Updating

To update your dotfiles to the latest version from this repository, navigate to the ~/.dotfiles directory and run:

```bash

git pull origin master
stow <configuration>
```

This will fetch the latest changes and update the symbolic links for the specified configuration.
### Contributions
If you have improvements or additions to suggest, feel free to open an issue or create a pull request. Contributions are welcome!

### License
This project is licensed under the MIT License. Feel free to use and modify the dotfiles according to your needs.

Happy coding!
