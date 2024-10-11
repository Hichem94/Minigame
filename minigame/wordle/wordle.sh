#!/bin/bash

########################################################################
function getRandomWord() {
    words=('Abuse' 'Adult' 'Agent' 'Anger' 'Apple' 'Award' 'Basis' 'Beach' 'Birth' 'Block' 'Blood' 'Board' 'Brain' 'Bread' 'Break' 'Brown' 'Buyer' 'Cause' 'Chain' 'Chair' 'Chest' 'Chief' 'Child' 'China' 'Claim' 'Class' 'Clock' 'Coach' 'Coast' 'Court' 'Cover' 'Cream' 'Crime' 'Cross' 'Crowd' 'Crown' 'Cycle' 'Dance' 'Death' 'Depth' 'Doubt' 'Draft' 'Drama' 'Dream' 'Dress' 'Drink' 'Drive' 'Earth' 'Enemy' 'Entry' 'Error' 'Event' 'Faith' 'Fault' 'Field' 'Fight' 'Final' 'Floor' 'Focus' 'Force' 'Frame' 'Frank' 'Front' 'Fruit' 'Glass' 'Grant' 'Grass' 'Green' 'Group' 'Guide' 'Heart' 'Henry' 'Horse' 'Hotel' 'House' 'Image' 'Index' 'Input' 'Issue' 'Japan' 'Jones' 'Judge' 'Knife' 'Laura' 'Layer' 'Level' 'Lewis' 'Light' 'Limit' 'Lunch' 'Major' 'March' 'Match' 'Metal' 'Model' 'Money' 'Month' 'Motor' 'Mouth' 'Music' 'Night' 'Noise' 'North' 'Novel' 'Nurse' 'Offer' 'Order' 'Other' 'Owner' 'Panel' 'Paper' 'Party' 'Peace' 'Peter' 'Phase' 'Phone' 'Piece' 'Pilot' 'Pitch' 'Place' 'Plane' 'Plant' 'Plate' 'Point' 'Pound' 'Power' 'Press' 'Price' 'Pride' 'Prize' 'Proof' 'Queen' 'Radio' 'Range' 'Ratio' 'Reply' 'Right' 'River' 'Round' 'Route' 'Rugby' 'Scale' 'Scene' 'Scope' 'Score' 'Sense' 'Shape' 'Share' 'Sheep' 'Sheet' 'Shift' 'Shirt' 'Shock' 'Sight' 'Simon' 'Skill' 'Sleep' 'Smile' 'Smith' 'Smoke' 'Sound' 'South' 'Space' 'Speed' 'Spite' 'Sport' 'Squad' 'Staff' 'Stage' 'Start' 'State' 'Steam' 'Steel' 'Stock' 'Stone' 'Store' 'Study' 'Stuff' 'Style' 'Sugar' 'Table' 'Taste' 'Terry' 'Theme' 'Thing' 'Title' 'Total' 'Touch' 'Tower' 'Track' 'Trade' 'Train' 'Trend' 'Trial' 'Trust' 'Truth' 'Uncle' 'Union' 'Unity' 'Value' 'Video' 'Visit' 'Voice' 'Waste' 'Watch' 'Water' 'While' 'White' 'Whole' 'Woman' 'World' 'Youth')

    size=${#words[@]}

    index=$(($RANDOM % $size))

    echo ${words[$index]}
}

function getInput {
    read -p "Quel est le mot à deviner? " -r
    echo "$REPLY"
}
########################################################################


echo -e "\e[95m########### WORDLE ###########\e[0m"
echo ""
echo -e "\e[95m########### REGLE ############\e[0m"
echo "Le joueur dispose de six tentatives pour trouver un mot de cinq lettres, en faisant des propositions et en obtenant des indices.
Chaque proposition doit être un mot valide de cinq lettres.
Après chaque essai, la couleur des cases changera pour montrer à quel point votre proposition est proche du mot cible."
echo ""
echo -e "\e[95m############ JEU #############\e[0m"


# Tirer le mot 
winning_word=$(getRandomWord)
winning_word="State"
winning_word_lower=$(echo "$winning_word" | tr '[:upper:]' '[:lower:]')
echo $winning_word

tentatives=0
gagne=0

tab0=(0 0 0 0 0)
tab1=(0 0 0 0 0)
tab2=(0 0 0 0 0)
tab3=(0 0 0 0 0)
tab4=(0 0 0 0 0)

#read -p "Quel est le mot à deviner ? " guess
guess=$(getInput)
while true;do
    
    # Checker si que des lettres et de longueur 5
    if [[ $guess =~ ^[A-Z][a-z]{4}$ ]];then
        
        # lower case
        guess_lower=$(echo "$guess" | tr '[:upper:]' '[:lower:]')
        
        tentatives=$((tentatives+1))

        # Boucle
        for (( i=0; i<${#winning_word_lower}; i++ )); do
            letter_w=${winning_word_lower:$i:1}
            
            for (( j=0; j<${#guess_lower}; j++  ));do
                letter_g=${guess_lower:$j:1}
                
                # echo "letter_g : $letter_g"
                # echo "letter_w : $letter_w"
                # echo "$i et $j"
                # Egale et à la même place
                if [ "$letter_w" == "$letter_g" ] && [ "$i" == "$j" ];then
                    if [ $i == 0 ];then
                        tab0[$i]=2
                    elif [ $i == 1 ];then
                        tab1[$i]=2
                    elif [ $i == 2 ];then
                        tab2[$i]=2
                    elif [ $i == 3 ];then
                        tab3[$i]=2
                    elif [ $i == 4 ];then
                        tab4[$i]=2
                    fi
                # Egale mais pas à ma même place
                elif [ $letter_w == $letter_g ]; then
                    if [ $j == 0 ] && [ ${tab0[$j]} != 2 ];then
                        tab0[$j]=1
                    elif [ $j == 1 ] && [ ${tab1[$j]} != 2 ];then
                        tab1[$j]=1
                    elif [ $j == 2 ] && [ ${tab2[$j]} != 2 ];then
                        tab2[$j]=1
                    elif [ $j == 3 ] && [ ${tab3[$j]} != 2 ];then
                        tab3[$j]=1
                    elif [ $j == 4 ] && [ ${tab4[$j]} != 2 ];then
                        tab4[$j]=1
                    fi
                fi
                
            done
        done
        
        tab=()
        # Additionner les colonnes de la matrice
        for (( i=0; i<${#tab0[@]}; i++ )); do
            tmp=$((${tab0[$i]} + ${tab1[$i]} + ${tab2[$i]} + ${tab3[$i]} + ${tab4[$i]}))
            tab+=($tmp)
        done

        # Coloration du background des lettres de $guess
        for (( i=0; i<${#tab0[@]}; i++ )); do
            if [ ${tab[$i]} == 2 ];then
                echo -ne "\e[102m${guess:$i:1}\e[0m "
            elif [ ${tab[$i]} == 1 ];then
                echo -ne "\e[100m${guess:$i:1}\e[0m "
            else
                echo -ne "${guess:$i:1} "
            fi
        done

        # Check si perdu
        if [ $tentatives -gt 6 ];then
            break
        fi

        # Check si gagné
        if [ $guess == $winning_word ];then
            gagne=1
            break   
        fi
        # echo ${tab[*]}
        # echo $winning_word

    else
        echo "Votre mot doit être de taille cinq et commencer par une majuscule."
    fi
    #read -p "Quelle est le mot à deviner ? " guess
    guess=$(getInput)

done

if [ $gagne == 1 ];then
    echo
    echo -e "\e[92mBravo ! Vous avez devinez le mot $winning_word en $tentatives tentative(s). \e[0m "
else
    echo
    echo -e "\e[91m Perdu ! Vous avez utilsé vos six tentatives.\e[0m "
fi

