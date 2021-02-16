# Boxes setup
Script automates setup of the Vim and Gnome (only Linux boxes) on new computers.

## Installation
```bash
bash <(curl -s https://raw.githubusercontent.com/exesse/boxes.setup/main/install.sh)
```

## Post installation setup
Start **gnome-tweak-tool** and select 'exesse*' in each respective category.
Select the same theme for **Plank**. Next add **Plank** to autostartup.
In extensions enable **blyr** and set to '10; 0.9; 1.00' for **Activities + Panel**.

## Vim shortrcuts
- F2 - show NerdTree
- F5 - run python code
- F7 - run flake8
- F8 - show tags list
- F9 - show task list
- cs"<> - Works for various file formats to change from "Hello world" to <>Hello</>. 
- gc - comment out one line
- gc2 - comment out two lines and so on
- :Git or :G - to run any git command from vim
- :sp {filename} - open a file and split window horizontally
- :vs {filename} - open a file and split window vertically
- ctrl + w + {g\h\j\k} - select window from left\bottom\top\right

## Feedback
Email bug reports, questions, discussions to [hi@exesse.org](mailto:hi@exesse.org).
