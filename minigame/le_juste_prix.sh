#! /bin/bash
echo -e "\e[95m########### LE JUSTE PRIX ###########\e[0m"
echo ""
echo -e "\e[95m### REGLE ###\e[0m"
echo " 1. Le programme génère un nombre cible aléatoire entre 1 et 100.
 2. Vous devez deviner ce nombre en indiquant un chiffre à chaque tentative.
 3. À chaque tentative, l'ordinateur vous dit si votre proposition est "trop haute" ou "trop basse"."
echo ""
echo -e "\e[95m############ JEU #############\e[0m"



score=0
parties=1
while true;do

    echo "Vous avez le choix entre :"
    echo "1.Choisir un niveau personnalisé"
    echo "2.Choisir la plage de nombres."
    read -p "(1|2): " awk
    while true;do
        if [ $awk == 1 ] || [ $awk == 2 ];then
            break
        fi
        read -p "(1|2): " awk
    done


    # CHOIX DU NIVEAU
    if [ $awk == 1 ];then
        echo -e "\e[95m########## NIVEAU #############\e[0m"
        echo "1. Facile    : Nombre entre 1 et 50, 15 tentatives."
        echo "2. Moyen     : Nombre entre 1 et 100, 10 tentatives."
        echo "3. Difficile : Nombre entre 1 et 500, 7 tentatives."

        echo ""
        read -p "Choisissez votre niveau : " niveau
        while true;do
            if [ $niveau == 1 ];then
                winning_number=$((1 + $RANDOM % 50))
                break
            elif [ $niveau == 2 ];then
                winning_number=$((1 + $RANDOM % 100))
                break
            elif [ $niveau == 3 ];then
                winning_number=$((1 + $RANDOM % 500))
                break
            fi
            read -p "Choisissez votre niveau : " niveau
        done
        echo ""
        echo -e "\e[95m######### NIVEAU $niveau ##########\e[0m"
    fi


    # CHOIX DE LA PLAGE DE NOMBRES
    if [ $awk == 2 ];then
        echo -e "\e[95m########## PLAGE #############\e[0m"
        echo "Choisissez la plage de nombres :"
        # Borne inférieure
        read -p "Borne inférieure :" inf
        while true;do
            if [[ $inf -lt 1 ]];then
                echo "La borne inférieure doit être supérieure à 1."
                read -p "Borne inférieure :" inf
            elif [[ $inf =~ ^[0-9]+$ ]] && [ $inf -ge 1 ];then
                break
            fi
        done

        # Borne supérieure
        read -p "Borne superieure :" sup
        while true;do
            if [[ $sup -le $inf ]];then
                echo "La borne supérieure doit être strictement supérieure à la borne inférieure."
                read -p "Borne superieure :" sup
            elif [[ $sup =~ ^[0-9]+$ ]] && [ $sup -gt $inf ];then
                break
            fi
        done
        # Génrérer un nombre
        winning_number=$(($RANDOM % ($sup - $inf + 1) + $inf))
    fi


    # Boucle principale
    echo "Jouer :"
    counter=1
    flag_perdu=0
    coups_joues=()
    read -p "[Parties $parties][Total de coups $score ][Coup $counter]: " guess
    while [[ $guess != $winning_number ]];do
    
        # Check
        if [[ $guess =~ ^[0-9]+$ ]];then
            counter=$((counter+1))
            score=$((score+1))
            coups_joues+=($guess)
            #echo "[Coup $counter] : $guess"
            if [ $guess -lt $winning_number ];then
                if [ $flag_perdu == 0 ];then
                    echo -e "\e[31mTrop bas !\e[0m"
                    echo -e "\e[37m###########\e[0m"
                    echo ""
                fi
            elif [ $guess -gt $winning_number ];then
                if [ $flag_perdu == 0 ];then
                    echo -e "\e[31mTrop haut !\e[0m"
                    echo -e "\e[37m###########\e[0m"
                    echo ""
                fi
            else
                break
            fi
        else
            echo -e "\e[31mMust be a number !\e[0m"
        fi

            # Pour NIVEAU
        if [ $awk == 1 ];then
            if [ $niveau == 1 ] && [ $counter -gt 15 ];then
                flag_perdu=1
                break
            elif [ $niveau == 2 ] && [ $counter -gt 10 ];then
                flag_perdu=1
                break
            elif [ $niveau == 3 ] && [ $counter -gt 7 ];then
                flag_perdu=1
                break
            fi
        fi
        echo -e "\e[96m[Coups joués : ${coups_joues[*]}]\e[0m"
        read -p "[Parties $parties][Total de coups $score ][Coup $counter] : " guess

    done

    if [ $flag_perdu == 1 ];then 
        echo -e "\e[31mPerdu !\e[0m"
    else
        echo -e "\e[92mFélicitation ! Vous avez trouver le juste prix $winning_number en $counter coups\e[0m"
        echo ""
    fi

    # Rejouer
    read -p "Rejouer (press a key) | Quitter (press q): " quit
    if [ $quit == "q" ];then
        echo "A bientôt !"
        parties=0
        score=0
        break
    fi
    
    parties=$((parties+1))
    clear >> /dev/null
done