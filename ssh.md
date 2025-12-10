```bash
pbcopy < ~/.ssh/id_rsa.pub
ssh-copy-id -i ~/.ssh/id_rsa.pub user@vm
ssh user@vm

ssh-dev() {
    local cmd="$*"
    ssh user@vm << EOF
    function k() { kubectl -n services "\$@"; }
    k $cmd
EOF
}

alias k=ssh-dev
```

ssh-add --apple-use-keychain ~/.ssh/id_rsa
ssh-add ~/.ssh/id_rsa

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
  IdentityFile ~/.ssh/103879u

