#!/bin/zsh
if [ -e drug_library.csv ]
then
    rm drug_library.csv
else
    echo "ok"
fi

printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "идентификатор ZINC" "название" "SMILES формула" "мол. вес, г/моль" "LogP" "брутто-формула" "число колец" "число тяжелых атомов" "число гетероатомов" "pH" "заряд" "число доноров H-связи" "число акцепторов H-связи" "площадь полярной поверхности, кв. А" "число вращающихся связей" >> drug_library.csv

for i in *.html; do
  zincID=$(awk -F '/' -v n=9 '/Resource Home/ { for (i = 1; i <= n; i++) getline; {print $3; exit} }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $zincID
  name=$(awk -v n=2 '/<title>/ { for (i = 1; i <= n; i++) getline; {print $1; exit} }' $i | sed 's/(//' | sed 's/)//')
  # echo $name
  smiles=$(awk -F  '"' '$6 == "substance-smiles-field" && $7 == " readonly value=" {print $8}' $i)
  # echo $smiles
  mw=$(awk -v n=10 '/Molecular Weight/ { for (i = 1; i <= n; i++) getline; print $1 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $mw
  logP=$(awk -v n=10 '/Partition Coefficient/ { for (i = 1; i <= n; i++) getline; print $1 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $logP
  formula=$(awk -v n=13 '/Mol Formula/ { for (i = 1; i <= n; i++) getline; print $1 }' $i | sed 's/<td>//' | sed 's/<\/td>//' | sed 's/\n//')
  # echo "$formula" >> formula.txt
  rings=$(awk -v n=13 '/th>Rings</ { for (i = 1; i <= n; i++) getline; {print $1; exit} }' $i | sed 's/<td>//' | sed 's/<\/td>//' | sed 's/\n//')
  # echo "$rings"
  heavyAtoms=$(awk -v n=13 '/Heavy Atoms/ { for (i = 1; i <= n; i++) getline; print $1 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $heavyAtoms
  heteroAtoms=$(awk -v n=13 '/Hetero Atoms/ { for (i = 1; i <= n; i++) getline; print $1 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $heteroAtoms
  pHRange=$(awk -F '>' '/title="More information about/ { {print $2; exit} }' $i | sed 's/<\/a//')
  # echo $pHRange
  netCharge=$(awk -F '>' '/td title="Net Charge"/ { {print $2; exit} }' $i | sed 's/<\/td//')
  # echo $netCharge
  hBondDonors=$(awk -F '>' '/td title="Hydrogen Bond Donors"/ { {print $2; exit} }' $i | sed 's/<\/td//')
  # echo $hBondDonors
  hBondAcceptors=$(awk -F '>' '/td title="Hydrogen Bond Acceptors"/ { {print $2; exit} }' $i | sed 's/<\/td//')
  # echo $hBondAcceptors
  polarSurfaceArea=$(awk -F '>' '/td title="Polar Surface Area"/ { {print $2; exit} }' $i | sed 's/<\/td//')
  # echo $polarSurfaceArea
  rotatableBonds=$(awk -F '>' '/td title="Rotatable Bonds"/ { {print $2; exit} }' $i | sed 's/<\/td//')
  # echo $rotatableBonds
  # пишу в библиотеку
  if [ -z "$name" ]
  then
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$zincID" "NA" "$smiles" "$mw" "$logP" "$formula" "$rings" "$heavyAtoms" "$heteroAtoms" "$pHRange" "$netCharge" "$hBondDonors" "$hBondAcceptors" "$polarSurfaceArea" "$rotatableBonds" >> drug_library.csv
  else
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$zincID" "$name" "$smiles" "$mw" "$logP" "$formula" "$rings" "$heavyAtoms" "$heteroAtoms" "$pHRange" "$netCharge" "$hBondDonors" "$hBondAcceptors" "$polarSurfaceArea" "$rotatableBonds" >> drug_library.csv
  fi
done

