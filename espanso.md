7550  brew install espanso
7551  espanso restart
7552  espanso service register
7553  espanso install basic-emojis
7554  espanso restart

$HOME/Library/Application Support/espanso

ls ~/Library/Application\ Support/espanso
vs ~/Library/Application\ Support/espanso

# espanso match file

# For a complete introduction, visit the official docs at: https://espanso.org/docs/

# You can use this file to define the base matches (aka snippets)
# that will be available in every application when using espanso.

# Matches are substitution rules: when you type the "trigger" string
# it gets replaced by the "replace" string.
matches:
  # Simple text replacement
  - trigger: ":espanso"
    replace: "Hi there!"
...

