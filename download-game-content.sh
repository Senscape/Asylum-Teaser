#!/bin/sh -e

zip=Asylum_Teaser_Unix.zip
sha256_1=96fac7e8bbbb5cb200ae41c87e48eb15b21ca3cf18791a40ebf2e0b4b519effd

if [ ! -f $zip ] ; then
    wget -O $zip "http://www.facethehorror.com/teaser/download.php?id=ubuntu"
fi

sha256_2=$(sha256sum $zip | head -c64)
if [ $sha256_2 != $sha256_1 ] ; then
    echo "$zip:"
    echo "SHA256 checksum is $sha256_2 but should be $sha256_1."
    echo "Delete '$zip' and try it again."
    exit 1
fi

unzip $zip
mv "Asylum Teaser" tmp
find tmp -type f -exec chmod 0644 '{}' \;

mkdir -p \
resources/audio \
resources/cursors \
resources/fonts \
resources/images \
resources/rooms/Cafeteria \
resources/rooms/CellsA \
resources/rooms/CorridorB \
resources/rooms/Infirmary \
resources/rooms/Showers

mv tmp/Resources/Nodes/cafeteria*.tex   resources/rooms/Cafeteria
mv tmp/Resources/Nodes/cellsa*.tex      resources/rooms/CellsA
mv tmp/Resources/Nodes/corridorb*.tex   resources/rooms/CorridorB
mv tmp/Resources/Nodes/infirmary*.tex   resources/rooms/Infirmary
mv tmp/Resources/Nodes/showers*.tex     resources/rooms/Showers

mv tmp/Resources/Video/cafeteria*.ogv   resources/rooms/Cafeteria
mv tmp/Resources/Video/cellsa*.ogv      resources/rooms/CellsA
mv tmp/Resources/Video/corridorb*.ogv   resources/rooms/CorridorB
mv tmp/Resources/Video/infirmary*.ogv   resources/rooms/Infirmary
mv tmp/Resources/Video/showers*.ogv     resources/rooms/Showers

mv tmp/Resources/Video/door_cafeteria*.ogv resources/rooms/Cafeteria
mv tmp/Resources/Video/door_cellsa*.ogv    resources/rooms/CellsA
mv tmp/Resources/Video/door_corridorb*.ogv resources/rooms/CorridorB
mv tmp/Resources/Video/door_infirmary*.ogv resources/rooms/Infirmary
mv tmp/Resources/Video/door_showers*.ogv   resources/rooms/Showers

mv tmp/Resources/Images/corridorb*       resources/rooms/CorridorB
mv tmp/Resources/Images/infirmary*       resources/rooms/Infirmary
mv tmp/Resources/Images/showers*         resources/rooms/Showers
mv tmp/Resources/Images/end_screen.png   resources/rooms/CellsA

mv tmp/Resources/Audio/*                resources/audio
mv tmp/Resources/Cursors/*              resources/cursors
mv tmp/Resources/Fonts/*                resources/fonts
mv tmp/Resources/Images/*               resources/images

rm -r tmp $zip

echo "Run 'dagon' within this directory to play the game."
echo "https://github.com/Senscape/Dagon"

