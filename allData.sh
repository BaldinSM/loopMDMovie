for i in *.html; do
  zincID=$(awk -F '/' -v n=9 '/Resource Home/ { for (i = 1; i <= n; i++) getline; {print $3; exit} }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $zincID
  name=$(awk -v n=2 '/<title>/ { for (i = 1; i <= n; i++) getline; {print $0; exit} }' $i | sed 's/(//' | sed 's/)//')
  # echo $name
  smiles=$(awk -F  '"' '$6 == "substance-smiles-field" && $7 == " readonly value=" {print $8}' $i)
  # echo $smiles
  mw=$(awk -v n=10 '/Molecular Weight/ { for (i = 1; i <= n; i++) getline; print $0 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $mw
  logP=$(awk -v n=10 '/Partition Coefficient/ { for (i = 1; i <= n; i++) getline; print $0 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $logP
  formula=$(awk -v n=13 '/Mol Formula/ { for (i = 1; i <= n; i++) getline; print $0 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $formula
  rings=$(awk -v n=13 '/>Rings</ { for (i = 1; i <= n; i++) getline; print $0 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $rings
  heavyAtoms=$(awk -v n=13 '/Heavy Atoms/ { for (i = 1; i <= n; i++) getline; print $0 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $heavyAtoms
  heteroAtoms=$(awk -v n=13 '/Hetero Atoms/ { for (i = 1; i <= n; i++) getline; print $0 }' $i | sed 's/<td>//' | sed 's/<\/td>//')
  # echo $heteroAtoms
done

