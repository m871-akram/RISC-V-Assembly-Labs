BEGIN {
  debut_re = "^\\s*"fonction":"
  prologue_re = "^\\s*"fonction"_fin_prologue:"
  epilogue_re = "^\\s*"fonction"_debut_epilogue:"
  debut = -1
  prologue = -1
  epilogue = -1
  ret = -1
}

{
  if ($0 ~ debut_re){
    if (debut=-1) debut=NR; else feuille = -2;
  }
  if ($0 ~ prologue_re){
    if (prologue=-1) prologue=NR; else prologue = -2;
  }
  if ($0 ~ epilogue_re){
    if (epilogue=-1) epilogue=NR; else epilogue = -2;
  }
  if ($0 ~ /^\s*ret\s*$/) {
    if (ret=-1) ret=NR; else ret = -2;
  }
}

END {
  if (debut > 0 && debut<prologue && prologue<epilogue && epilogue<ret){
    exit 0
  }
  if (debut<0) {
    print "Étiquette de la fonction "fonction" manquante"
  }
  if (prologue<0) {
    print "Attention à l'étiquette "fonction"_fin_prologue"
  }
  if (epilogue<0) {
    print "Attention à l'étiquette "fonction"_debut_epilogue"
  }
  if (ret<0){
    print "L'instruction ret doit être à la fin de la fonction sans commentaire autour"
  }
  if (debut >0 && prologue>0 && ret>0 && epilogue>0){
    print "Les étiquettes dans votre fonction doivent être, dans l'ordre : début de fonction , fin de prologue, debut d'epilogue. Enfin votre fonction doit se terminer par une unique instruction ret."
  }
  exit 1
}
