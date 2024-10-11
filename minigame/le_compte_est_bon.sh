#! /bin/bash


# Génrérer un nombre entre 1 et 100
winning_number=$((1 + $RANDOM % 100))


echo "########### LE COMPTE EST BON ###########"
echo ""
echo "### REGLE ###"
echo "Le jeu se joue dans le terminal. À chaque coup, vous devez entrer une opération\
en utilisant deux nombres parmi ceux fournis, puis continuer avec le résultat de cette\
opération jusqu\’à ce que vous atteigniez le nombre cible ou que vous échouiez."
echo ""
echo "############ JEU #############"
