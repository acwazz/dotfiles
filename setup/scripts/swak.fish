function swak.secrets.pwd --argument-names length charchoice
    set -q length[1]
    or set length "16"
    set -q charchoice[1]
    or set charchoice "[A-Za-z0-9\*!\?\_\-\$]"
    tr -dc $charchoice < /dev/urandom | head -c $length ; echo ''
end


function swak.secrets.token --argument length
    set -q length[1]
    or set length "16"
    python3 -c "import secrets; print(secrets.token_urlsafe($length))"
end


function swak.secrets.ecdsa
    set secret (openssl ecparam -name prime256v1 -genkey -noout | string collect)
    set public (echo $secret | openssl ec -pubout | string collect)
    echo $secret
    echo "----- ----- ---- ----"
    echo $public
end 

function swak.git
    git config credential.helper "store"
    git config pull.rebase false
    git config user.name "Emanuele Addis"
    git config user.username "acwazz"
    git config user.email "ustarjem.acwazz@gmail.com"
end