#!/bin/bash

set -e
tf_path=$1
tf_state=$2

ip=$(${tf_path}         output -state=${tf_state} do_droplet)
ca_crt=$(${tf_path}     output -state=${tf_state} openvpn_ca_pem)
client_crt=$(${tf_path} output -state=${tf_state} openvpn_client_pem)
client_key=$(${tf_path} output -state=${tf_state} openvpn_client_key)
ta_key=$(cat secrets/openvpn-ta.key)

dest="secrets/${ip}.ovpn"

cat > ${dest} <<EOF
client
proto udp
comp-lzo
remote ${ip} 1194
redirect-gateway def1
key-direction 1
keepalive 10 60
dev-type tun
dev tun
cipher AES-256-CBC
<ca>
${ca_crt}
</ca>
<cert>
${client_crt}
</cert>
<key>
${client_key}
</key>
<tls-auth>
${ta_key}
</tls-auth>
EOF

echo "file '${dest}' generated"
echo "OK"
