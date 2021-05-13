#! /bin/bash
#set -x

###
# admin:     tz1TQyYUuFbAroVARwhh5Fgqu2JE9HrvNi3a
# user_cool: tz1dceN5Nuf8qvVQqUT6FwHxESs1fTPyoGAL
# user_wine: tz1ZbHX1r4CjEv4E1hsShdVwywchSsr5McFm
###

cli=completium-cli

admin_alias=werenode_admin
user_cool_alias=user_cool
user_wine_alias=user_wine

addressbook_alias=werenode_addressbook
token_alias=werenode_token
evse_cool_alias=werenode_evse_cool
evse_plug_alias=werenode_evse_plug
evse_wine_alias=werenode_evse_wine

admin=`$cli show address $admin_alias`
user_cool=`$cli show address $user_cool_alias`
user_wine=`$cli show address $user_wine_alias`


$cli set endpoint https://florencenet.smartpy.io
$cli set account $admin_alias

$cli deploy addressbook.arl --named $addressbook_alias --init "$admin" --force

$cli deploy token.arl       --named $token_alias --init "$admin" --force

$cli deploy evse.arl        --named $evse_cool_alias --init "($admin, \"48.775379177873134,2.044936695048847\")" --force
$cli deploy evse.arl        --named $evse_plug_alias --init "($admin, \"48.8701025,2.2909664\")" --force
$cli deploy evse.arl        --named $evse_wine_alias --init "($admin, \"49.1885924,-0.3609428\")" --force

evse_cool=`$cli show address $evse_cool_alias`
evse_plug=`$cli show address $evse_plug_alias`
evse_wine=`$cli show address $evse_wine_alias`

$cli call $addressbook_alias --entry add_whitelist --with $user_cool --force
$cli call $addressbook_alias --entry add_whitelist --with $user_wine --force

$cli call $addressbook_alias --entry addupdate_evse --as $user_cool --with "(\"WNCooL\", $evse_cool, $admin, \"https://evsemanager.werenode.com\", 5000, $user_cool)" --force
$cli call $addressbook_alias --entry addupdate_evse --as $user_cool --with "(\"WNPLUG\", $evse_plug, $admin, \"https://evsemanager.werenode.com\", 5000, $user_cool)" --force
$cli call $addressbook_alias --entry addupdate_evse --as $user_wine --with "(\"WNWine\", $evse_wine, $admin, \"https://evsemanager.werenode.com\", 5000, $user_wine)" --force

$cli call $token_alias --entry transfer --with "($admin, $user_cool, 100_000)" --force
$cli call $token_alias --entry transfer --with "($admin, $user_wine, 100_000)" --force
