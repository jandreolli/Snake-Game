###############################################################################
# Auteurs: ANDREOLLI Justine
#	   LIS Ambre 
# Groupe : TD4 TP7
#
# Projet MIPS Jeu du Snake dans le cadre de l'UE "Architecture des Ordinateurs"
# L2S3 - UFR Mathématique Informatique Strasbourg 2021
#
###############################################################################
#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0		  

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4


PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green									
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115		
beq $t0 $t1 GIhaut
li $t1 122		
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
li $a0 500
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

######
messageNulScore:   .asciiz  "Quelle pitoyable prestation ! Score : "
messageBravoScore: .asciiz  "Quelle magnifique prestation ! Bravo ! Score : "
messageNiveau:	   .asciiz  "  Niveau : "
numNiveau:	   .word 0	
######

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################

majDirection:

# En haut, ... en bas, ... à gauche, ... à droite, ... ces soirées là ...

##########################################
### registres:

### $s0 : getInputVal (la nouvelle position)
### $s1 : snakeDir

### $t0 : 4 (erreur)
##########################################

# prologue MajDirection
		addi $sp $sp -8					# on alloue de la place dans la pile (8 octets pour stocker 2 entiers)
		sw   $s0 0($sp)					# Mem[0 + $sp] : $s0
		sw   $s1 4($sp)				
		
# corps MajDirection
		move $s0 $a0					# $s0 : $a0 (getInputVal)
		lw   $s1 snakeDir				# $s1 : snakeDir

		###  On vérifie que getInputVal != 4 (erreur)  ###
		li   $t0 4					# $t0 : 4
		beq  $s0 $t0 finMajDirection			# si getInputVal == 4(erreur), aller à finMajDirection
		
		###  On cherche à quelle position (0,1,2 ou 3) correspond getInputVal  ###
		beq  $s0 0 positionHaut				# si getInputVal == haut, aller à positionHaut
	  	beq  $s0 1 positionDroite 			# si getInputVal == droite, aller à positionDroite
	  	beq  $s0 2 positionBas				# si getInputVal == bas, aller à positionBas
	  	beq  $s0 3 positionGauche			# si getInputVal == gauche, aller à positionGauche
	  	 
	  	###  On vérifie si la commande est illégale (pas de demi-tour) ###
  positionHaut: beq  $s1 2 finMajDirection			# si snakeDir == bas, aller à finMajDirection
     		j miseAJourDirection				# sinon autorisé à mettre à jour la direction
     		
positionDroite: beq  $s1 3 finMajDirection			# si snakeDir == gauche, aller à finMajDirection
     		j miseAJourDirection	
     		 		
   positionBas: beq  $s1 0 finMajDirection			# si snakeDir == haut, aller à finMajDirection
     		j miseAJourDirection
     		
positionGauche: beq  $s1 1 finMajDirection			# si snakeDir == droite, aller à finMajDirection
     		j miseAJourDirection 
	
		###  Si getInputVal est valide, on met à jour la direction  ###
miseAJourDirection:
		sw   $s0 snakeDir   				# snakeDir : $s0 (la nouvelle position)
		j finMajDirection
	
# epilogue MajDirection

	finMajDirection:
		lw   $s0 0($sp)					# $s0 : Mem[0 + $sp]
		lw   $s1 4($sp)				
		addi $sp $sp 8					# on free la pile 
	
		jr   $ra

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:

# prologue UpdateGameStatus
		addi $sp $sp -20				# on alloue de la place dans la pile (20 octets pour stocker 5 entiers)
		sw $s0 0($sp)					# Mem[0 + $sp] : $s0
		sw $s1 4($sp)					
		sw $s2 8($sp)					
		sw $s3 12($sp)					
		sw $ra 16($sp)					
		

# corps UpdateGameStatus
		lw $s0 snakeDir					# $s0 : snakeDir
		lw $s1 snakePosX($zero)				# $s1 : snakePosX(0) (= la valeur de la tête du serpent en x)
		lw $s2 snakePosY($zero)				# $s2 : snakePosY(0) (= la valeur de la tête du serpent en y)
		lw $s3 tailleSnake				# $s3 : tailleSnake
		
		###  On regarde si la taille du serpent == 1  ###
		li  $t0 1					# $t0 : 1
		beq $s3 $t0 teteSnake				# si tailleSnake == 1, aller à teteSnake
		
		# sinon va à corpsSnake
		
		
##########################################
## Fonction corpsSnake
##########################################
### registres:

### $s3 : tailleSnake

### $a1 : adresse snakePosX(0)/ snakePosY(0)

### $t0 : adresse de la position courante
### $t1 : valeur de la case précédente
##########################################

corpsSnake:
		###  On fait le décalage pour snakePosX  ###
	decalageX:
		la $a1 snakePosX($zero)				# $a1 : adresse de la 1ère case de snakePosX
		
		mulu $t0 $s3 4		        		# $t0 : tailleSnake * 4 = offset de la fin du tableau snakePosX
		addu $t0 $a1 $t0            			# $t0 : adresse du  début du tableau + offset = adresse de la fin de la dernière case du tableau snakePosX

		loopDecalageX:
		beq  $t0 $a1 decalageY      			# si adresse de la position courante dans le tableau == adresse du début du tableau, aller à decalageY
		lw   $t1 -4($t0)               			# $t1 : on charge le contenu (la valeur) de la case précédente 
		sw   $t1 0($t0)                 		# case courante : $t1 (on a copié la valeur x qui se trouve à $t1)
		subu $t0 $t0 4                			# $t0 : adresse courante - 4 = on recule d'une case --> nouvelle case courante
		j loopDecalageX
		
		
		###  On fait le décalage pour snakePosY  ###
	decalageY:
		la $a1 snakePosY($zero)				# $a1 : adresse de la 1ère case de snakePosY
		
		mulu $t0 $s3 4		        		# $t0 : tailleSnake * 4 = offset de la fin du tableau
		addu $t0 $a1 $t0            			# $t0 : adresse du  début du tableau + offset = adresse de la fin de la dernière case du tableau snakePosY

		loopDecalageY:
		beq  $t0 $a1 teteSnake      			# si adresse de la position courante dans le tableau == adresse du début du tableau, aller à teteSnake
		lw   $t1 -4($t0)               			# $t1 : on charge le contenu de la case précédente
		sw   $t1 0($t0)                 		# case courante : $t1
		subu $t0 $t0 4                			# $t0 : adresse courante - 4 = on recule d'une case --> nouvelle case courante
		j loopDecalageY
	


##########################################
## Fonction teteSnake
##########################################
### registres:

### $s0 : snakeDir
### $s1 : valeur de snakePosX(0)
### $s2 : valeur de snakePosY(0)
##########################################

teteSnake:
		###  On bouge la tête du serpent en fonction de la direction  ###
		beq $s0 0 serpentHaut				# si snakeDir va vers le haut   --> aller à serpentHaut
		beq $s0 1 serpentDroite				# si snakeDir va vers la droite --> aller à serpentDroite
		beq $s0 2 serpentBas				# si snakeDir va vers le bas    --> aller à serpentBas
		beq $s0 3 serpentGauche         		# si snakeDir va vers la gauche --> aller à serpentGauche

   serpentHaut: addi $s1 $s1 1					# $s1 : on incrémente la valeur de la 1ère case de snakePosX
	       	sw   $s1 snakePosX($zero)			# snakePosX(0) : la tête du serpent avance vers le haut
	       	j nourriture

 serpentDroite: addi $s2 $s2 1					# $s2 : on incrémente la valeur de la 1ère case de snakePosY
	       	sw   $s2 snakePosY($zero)			# snakePosY(0) : la tête du serpent avance vers la droite
	       	j nourriture

    serpentBas: addi $s1 $s1 -1					# $s1 : on incrémente la valeur de la 1ère case de snakePosX
	       	sw   $s1 snakePosX($zero)			# snakePosX(0) : la tête du serpent avance vers le bas
	       	j nourriture

 serpentGauche: addi $s2 $s2 -1					# $s2 : on incrémente la valeur de la 1ère case de snakePosY
	       	sw   $s2 snakePosY($zero)			# snakePosY(0) : la tête du serpent avance vers la gauche
	       	j nourriture    
	    



##########################################
## Fonction nourriture
##########################################
### registres:

### $s1 : valeur de snakePosX(0)
### $s2 : valeur de snakePosY(0)
### $s3 : tailleSnake

### $t0 : valeur x de candy
### $t1 : valeur y de candy
### $t2 : scoreJeu
##########################################
 
nourriture:
		###  On range la valeur de x et y de candy dans des registres  ###
		lw $t0 candy					# $t0 : la valeur x de candy
		lw $t1 candy + 4				# $t1 : la valeur y de candy
		
		###  On regarde si la valeur de la tête du serpent se trouve sur la nourriture  ###
		bne $s1 $t0 finNourriture			# si valeur snakePosX(0) != la valeur x de candy, aller à finNourriture
		bne $s2 $t1 finNourriture			# si valeur snakePosY(0) != la valeur y de candy, aller à finNourriture

		###  On incrémente tailleSnake si la nourriture a été mangée  ###
		addi $s3 $s3 1					# $s3 : on incrémente la taille du serpent 
		sw   $s3 tailleSnake				# tailleSnake : on range la nouvelle valeur de la taille du serpent 

		###  On incrémente le score puisque la nourriture a été mangée  ###
		lw   $t2 scoreJeu				# $t2 : scoreJeu
		addi $t2 $t2 1					# $t2 : on incrémente scoreJeu
		sw   $t2 scoreJeu				# scoreJeu : on range la nouvelle valeur de scoreJeu

		###  On donne à candy une nouvelle valeur aléatoire  ###
		jal newRandomObjectPosition
		sw $v0 candy					# candy : sa nouvelle valeur x
		sw $v1 candy + 4				# candy + 4 : sa nouvelle valeur y
		
		# va à obstacles
		j obstacles
		
     	finNourriture:      	       	       
		j finUpdateGameStatus


##########################################
## Fonction obstacles
##########################################
### registres:

### $a1 : adresse obstaclesPosX(0)
### $a2 : adresse obstaclesPosY(0)

### $t0 : numObstacles
### $t1 : numObstacles * 4 (offset case courante)
### $t2 : adresse obstaclesPosX(0) + offset courant
### $t3 : adresse obstaclesPosY(0) + offset courant
##########################################

obstacles:
     		###  On ajoute un nouvel obstacle à une position aléatoire  ### 
     		jal newRandomObjectPosition
     		
     		la $a1 obstaclesPosX($zero)			# $a1 : adresse de obstaclesPosX(0)
      		la $a2 obstaclesPosY($zero)			# $a2 : adresse de obstaclesPosY(0)
     		
     		###  On calcule à quel offset des tableaux obstaclePosX et obstaclePosY on met les coordoonées du nouvel obstacle  ###
     		lw   $t0 numObstacles				# $t0 : numObstacles
     		mulu $t1 $t0 4					# $t1 : numObstacles * 4
     		addu $t2 $a1 $t1				# $t2 : adresse obstaclePosX(0) + offset courant
     		addu $t3 $a2 $t1				# $t3 : adresse obstaclePosY(0) + offset courant
     		
     		sw $v0 0($t2)					# on range la valeur x du nouvel obstacle dans obstaclePoxX au bon offset
     		sw $v1 0($t3)					# on range la valeur y du nouvel obstacle dans obstaclePoxY au bon offset
     		
      		###  On incrémente le nombre d'obstacles  ###
     		addi $t0 $t0 1					# $t0 : on incrémente numObstacles
     		sw   $t0 numObstacles				# numObstacles : nouvelle valeur de numObstacles
      			
    	        # va à finUpdateGameStatus
    	        	       	       

# epilogue UpdateGameStatus

# jal hiddenCheatFunctionDoingEverythingTheProjectDemandsWithoutHavingToWorkOnIt
	finUpdateGameStatus:
		lw $s0 0($sp)
		lw $s1 4($sp)
		lw $s2 8($sp)
		lw $s3 12($sp)
		lw $ra 16($sp)	
	
		addi $sp $sp 20					# on free
		
		jr $ra

############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:
# prologue
		addi $sp $sp -16				# on alloue de la place dans la pile (16 octets pour stocker 4 entiers)
		sw   $s0 0($sp)					# Mem[0 + $sp] = $s0
		sw   $s1 4($sp)
		sw   $s2 8($sp)
		sw   $s3 12($sp)
	
	
# corps de conditionFinJeu
		lw $s0 snakePosX($zero)				# $s0 : valeur de snakePosX(0)	
		lw $s1 snakePosY($zero)				# $s1 : valeur de snakePosY(0)
		la $s2 obstaclesPosX($zero)			# $s2 : adresse obstaclesPosX(0)
		la $s3 snakePosX($zero)				# $s3 : adresse snakePosX(0)	

		# va à depasseGrille

##########################################
## Fonction depasseGrille
##########################################
### registres:

### $s0 : valeur de snakePosX($zero)
### $s1 : valeur de snakePosY($zero)

### $t0 : tailleGrille
##########################################

depasseGrille:
		lw $t0 tailleGrille				
		
		###  Si la valeur de la tête du serpent >= tailleGrille ou < 0, on a perdu  ###
		bge $s0 $t0 finConditionJeuPerdu		# si valeur de snakePosX($zero) >= tailleGrille, aller à finConditionJeuPerdu
		bge $s1 $t0 finConditionJeuPerdu		# si valeur de snakePosY($zero) >= tailleGrille, aller à finConditionJeuPerdu
		blt $s0 0 finConditionJeuPerdu			# si valeur de snakePosX($zero) < 0, aller à finConditionJeuPerdu
		blt $s1 0 finConditionJeuPerdu			# si valeur de snakePosY($zero) < 0, aller à finConditionJeuPerdu

		# sinon va à eatObstacle


##########################################
## Fonction eatObstacle
##########################################
### registres:

### $s0 : valeur de snakePosX(0)
### $s1 : valeur de snakePosY(0)
### $s2 : adresse obstaclesPosX(0)

### $a0 : valeur de obstaclesPosY($t4)

### $t0 : numObstacles
### $t1 : numObstacles * 4 
### $t2 : adresse courante qui part de la fin 
#         du tableau obstaclesPosX
### $t3 : valeur de la case courante 
### $t4 : compteur (offset)
##########################################
eatObstacle:
		###  Est-ce que le serpent a mangé un obstacle?  ###
		lw $t0 numObstacles				# $t0 : numObstacles	
		li $t4 0					# $t4 : pour connaitre l'offset = compteur
	
		###  On regarde si la valeur de snakePosX(0) est également présente dans un autre case de ObstaclesPosX  ###
	eatObstacleX:
		mulu $t1 $t0 4					# $t1 : numObstacles * 4 = offset
		addu $t2 $s2 $t1				# $t2 : adresse obstaclesPosX(0) + offset = adresse fin du tableau obstaclesPosX 
	
		move $t4 $t1					# $t4 : $t1 (pour récupérer l'offset pour eatObstacleY)
		
		beginEatObstacleX:	
		blt $t2 $s2 eatSnake				# si adresse case courrante < adresse début obstaclesPosX, aller à eatSnake
		lw  $t3 0($t2) 					# $t3 : valeur de la case courante
			beq  $s0 $t3 eatObstacleY		# si valeur de snakePosX(0) == valeur de la case courante, aller à eatObstacleY
			subu $t2 $t2 4 				# $t2 : adresse courante moins une case
			subu $t4 $t4 4				# $t4 : enlève 4 au compteur
		
			j beginEatObstacleX
		
		###  Après avoir récupéré l'offset où snakePosX(0) == obstaclesPosX(offset), on vérifie si au même offset, snakePosY(0) == obstaclesPosY(offset)  ###		
	eatObstacleY:
		lw  $a0 obstaclesPosY($t4)			# a0 : valeur de obstaclesPosY(même offset que obstaclesPosX)
		bne $a0 $s1 eatSnake				# si valeur de obstaclesPosY(même offset que obstaclesPosX) != valeur de snakePosY(0), aller à eatSnake 
		
		j finConditionJeuPerdu
		


##########################################
## Fonction eatSnake
##########################################
### registres:

### $s0 : valeur de snakePosX(0)
### $s1 : valeur de snakePosY(0)
### $s3 : adresse de snakePosX(0)

### $a0 : valeur de SnakePosY($t4)

### $t0 : tailleSnake
### $t1 : tailleSnake * 4 
### $t2 : adresse courante
### $t3 : valeur de la case courante 
### $t4 : compteur(offset)
##########################################
eatSnake:
		###  Est-ce que le serpent a pratiqué de l'auto-cannibalisme?  ###
		lw $t0 tailleSnake				# $t0 : tailleSnake
		li $t4 0					# $t4 : connaitre offset = compteur
		
		
		###  On regarde si valeur de snakePosX(0) est également présente dans une autre case de snakePosX  ###
	eatSnakeX:
		mulu $t1 $t0 4					# $t1 : tailleSnake * 4 
		addu $t2 $s3 $t1				# $t2 : adresse de snakePosX(0) + offset = adresse de la fin de la dernière case du tableau 
	
		move $t4 $t1					# $t4 : $t1 (pour récupérer l'offset pour eatSnakeY)
		
		beginEatSnakeX:	
		beq $t2 $s3 finConditionJeuContinue		# si adresse de la case courrante == adresse snakePosX(0), aller à finConditionJeuContinue
		lw $t3 0($t2) 					# $t3 : valeur de la case courante
			beq $s0 $t3 eatSnakeY			# si valeur de snakePosX(0) == valeur de la case courante, aller à eatSnakeY
			subu $t2 $t2 4 				# $t2 : adresse courante moins une case
			subu $t4 $t4 4				# $t4 : enlève 4 au compteur
		
			j beginEatSnakeX
		
		###  Après avoir récupéré l'offset où snakePosX(0) == snakePosX(offset), on vérifie si au même offset, snakePosY(0) == snakePosY(offset)  ###		
	eatSnakeY:
		lw $a0 snakePosY($t4)				# $a0 : valeur de snakePosY(même offset que snakePosX)
		bne $a0 $s1 finConditionJeuContinue		# si valeur de snakePosY(même offset que snakePosX) != snakePosY(0), aller à finConditionJeuContinue
		
		j finConditionJeuPerdu
		


# épilogue
	finConditionJeuContinue:
		lw $s0 0($sp)
		lw $s1 4($sp)
		lw $s2 8($sp)
		lw $s3 12($sp)
		addi $sp $sp 16					# on free
	
		li $v0 0					
		jr $ra

	finConditionJeuPerdu:
		lw $s0 0($sp)
		lw $s1 4($sp)
		lw $s2 8($sp)
		lw $s3 12($sp)
		addi $sp $sp 16					# on free

# Aide: Remplacer cette instruction permet d'avancer dans le projet.
		li $v0 1					# perdu
		jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
##########################################
### registres:

### $a0 : messageBravoScore/ messageNulScore 

### $t0 : scoreJeu
### $t1 : 3
### $t2 : scoreNiveau
##########################################

# Fin.
		lw $t0 scoreJeu					# $t0 : scoreJeu

		bge $t0 6 bravoScore				# si scoreJeu >= 6, aller à bravoScore
		j nulScore					# sinon aller à nulScore
	
	
		###  Afficher message gentil ou méchant en fonction de scoreJeu  ###  
	bravoScore:
		la $a0 messageBravoScore			
		li $v0 4
		syscall
	
		j scoreFinal
	
	nulScore:
		la $a0 messageNulScore
		li $v0 4
		syscall
	
		j scoreFinal
		
		
		###  Affiche le score du joueur  ###
	scoreFinal:
		li $v0 1
		lw $a0 scoreJeu
		syscall

		j Niveau


		 ###  Incrémentation du niveau du joueur  ###
	Niveau:
		li $t1 3					# $t1 : 3 
		lw $t2 numNiveau				# $t2 : scoreNiveau
		
	
		###  Lorsque scoreJeu est supérieur à un multiple de 3, le niveau est incrémenté  ###
		beginNiveau:					
			blt $t0 $t1 finNiveau			# si scoreJeu < 3, aller à finNiveau (le niveau n'augmente pas)
			addi $t0 $t0 -3				# $t0 : scoreJeu - 3 
			addi $t2 $t2 1				# $t2 : numNiveau + 1 
			sw $t2 numNiveau			# numNiveau : la nouvelle valeur du niveau
			
			j beginNiveau
			
			
		###  Afficher le niveau du joueur  ###
	finNiveau:
		li $v0 4
		la $a0 messageNiveau
		syscall
		
		li $v0 1
		lw $a0 numNiveau
		syscall
		
	
		jr $ra
		
	
