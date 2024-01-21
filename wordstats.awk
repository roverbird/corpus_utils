{$0=tolower($0);gsub("[:;.,()!?-]"," ");t++;
  for(w=1;w<=NF;w++){l[t,$w]++;g[$w]++}}

END {for(w in g) if(g[w]<10) delete g[w]; else if(g[w]>100000) delete g[w]; else printf w " "; print "";
  for(i=1;i<=t;i++){ for(w in g) printf +l[i,w]" "; print "";}}
