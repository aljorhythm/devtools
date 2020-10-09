 #!/bin/bash

function install {
    echo $1
    id=`mas search "$1" | head -1 | grep -o '[0-9]\+' | head -1`
    echo "id: $id"
    mas purchase $id
    mas install $id
}

install "telegram"
install "whatsapp for desktop"
install "slack"