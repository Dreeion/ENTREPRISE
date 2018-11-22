/***********************************************************/
// Nom du programme : TCDE
// Auteur(s) :Dreion & Daeranil
// Date :19/11/2018
// Version :0.004
/***********************************************************/
// Description du programme :
//===========================
// Un jeu dans l'espace.
/***********************************************************/
 

/***********************************************************/
/******************* Entête déclarative ********************/
/***********************************************************/ 



// --- inclusion des librairies utilisées ---


// --- librairie sons ---
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// --- déclaration objets ---
boolean a;
int xJoueur;
int yJoueur;
int vitesse;//vitesse
int idMahmoud;
int yf;
int idTir;
int vie;
PImage joueur;
PImage mahmoud;
PImage fond;
PImage UI;
float fin;
float xMahmoud[]= new float[100];
float yMahmoud[]= new float[100];
float xTir[]= new float[50];
float yTir[]= new float[50];
Minim minim;
AudioSnippet ping;

// --- déclaration variables globales ---

/********************* Fonction SETUP **********************/
// fonction d'initialisation exécutée 1 fois au démarrage
/***********************************************************/

void setup ()
{  
 
  // --- initialisation des musiques ---
  minim = new Minim(this);
  ping = minim.loadSnippet("Musique.wav");
  ping.play();
  
  // --- initialisation fenêtre de base ---
  //fullScreen();
  size(500, 1000); // ouvre une fenêtre xpixels  x ypixels
  background(0,0,0); // couleur fond fenetre ( noir )
 
  // ---- initialisation paramètres graphiques utilisés ---

  noCursor();

  // --- attributions des variables images ---

  fond = loadImage("data/Images/stars.jpg");               //Charger l'image du fond d'écran
  fond.resize(width,height);                               // Taille du fond d'écran 

  joueur = loadImage("data/Images/joueur.png");           //Charger l'image du vaisseau du joueur
  joueur.resize(width/8,height/10);                       //Taille du joueur

  mahmoud = loadImage("data/Images/mahmoud1.png");       //Charger l'image des ennemis
  mahmoud.resize(75,75);                                 //Taille des ennemis

  UI = loadImage("data/Images/UI.png");

  // --- attributions des variables numériques ---

  xJoueur=width/2-width/8/2;yJoueur=height-height/10*2; //Coordonnées de départ du joueur
  vitesse=20;                                                 // Vitesse des ennemis
  vie=300;                                               //Point de vie de base du joueur
  yf=0;                                                  //Coordonnée de départ du fond d'écran (pour le défilement verticale)
  
// --- définition des coordonnées des ennemis de la première vague

  idMahmoud=1;
  while (idMahmoud<=99){
      xMahmoud[idMahmoud] = random(425);     
      yMahmoud[idMahmoud] = random(-10000,-1000);
      idMahmoud=idMahmoud+1;}
      
}
/********************** Fonction DRAW **********************/
//             fonction exécutée en boucle
/***********************************************************/

void  draw()
{
 // --- affichage et défilement du fond d'écran 
  image (fond,0,yf);
  image (fond,0,yf-height);
  if (yf>=height){yf=yf-height;}
  yf=yf+1;
   
 // --- définition du delais avant la fin d'une vague avec les coordonnées --- 
  while (idMahmoud<=99){
   fin = fin + yMahmoud[idMahmoud];
   idMahmoud=idMahmoud+1;}
  idMahmoud=1;
  
//-------------------------------à effacer----------------------------------------------
 // --- Mod developeur ---
 fill (255);
  text ("niveau="+ (vitesse-19),10,20);
  text ("fin de la vague dans="+((fin-129000)*-1),10,40);
  text ("Vie:"+vie,10,60);
//-------------------------------à effacer----------------------------------------------



// --- détection de la fin d'une vague + génération d'une nouvelle vague --- 

  if (fin >= 129000) {idMahmoud=1;vitesse=vitesse+1;
  while (idMahmoud<=99){
      xMahmoud[idMahmoud] = random(425);     
      yMahmoud[idMahmoud] = random(-10000,-1500);
      idMahmoud=idMahmoud+1;} }
  fin = 0;

  // --- affichage + déplacement des ennemis ---
  while (idMahmoud<=99){
    if (yMahmoud[idMahmoud]>-100 && yMahmoud[idMahmoud]<1100) {image (mahmoud,xMahmoud[idMahmoud],yMahmoud[idMahmoud]);}
    if (yMahmoud[idMahmoud]<1300) {yMahmoud[idMahmoud]=yMahmoud[idMahmoud]+vitesse/2;}
    idMahmoud=idMahmoud+1;} 
  idMahmoud=1;
 
 // --- affichage + déplacement du joueur ---
  
  image (joueur,xJoueur-width/8/2,yJoueur-height/10/2);
  if (xJoueur<mouseX){xJoueur=xJoueur+(mouseX-xJoueur)/10;}
  if (xJoueur>mouseX){xJoueur=xJoueur+(mouseX-xJoueur)/10;}
  if (yJoueur>mouseY){yJoueur=yJoueur+(mouseY-yJoueur)/10;}
  if (yJoueur<mouseY){yJoueur=yJoueur+(mouseY-yJoueur)/10;}

  // --- Gestion des collisions entre le joueur et les ennemis ---

    while (idMahmoud<=99){
    if ((xJoueur+width/8/2+1>= xMahmoud[idMahmoud]) && (xJoueur<= xMahmoud[idMahmoud]+105) && (yJoueur+height/10/2-5>= yMahmoud[idMahmoud]) &&  (yJoueur-10<= yMahmoud[idMahmoud]+100)) {
    vie=vie-1;}
  idMahmoud=idMahmoud+1;
}
  idMahmoud=1;  
  
  // --- Gestion des tirs du joueur mais c'est un peut buguer pour l'instant pffff ---
   while (idTir<=49){  
     if (xTir[idTir]<500){
       yTir[idTir] = yTir[idTir]-10;
     if ( yTir[idTir]<=-10){xTir[idTir]=1000;}
       fill (#FF0303);rect(xTir[idTir]-1,yTir[idTir],2,-50);}
     if (keyPressed) {
        if (key == 'a' || key == 'A'){a=true;break;}}
        if (a){xTir[idTir]=xJoueur; yTir[idTir]=yJoueur;}
     
   idTir=idTir+1;
 
 }
  idTir=1;
 
   // --- gestion des points de vies et de la défaite ---
   
fill (#FF0000);rect (50,950,vie,30);
if (vie <= 0) {rect(0,0,width,height);}
  
  // --- Interface Utilisateur ---
  image (UI,0,850);  
  
  // --- delais pendant le quel le joueur vois le resultat de la boucle ---
  delay (1);
   
 }

/********************** Fonction STOP **********************/
//          fonction exécutée quand le programme est fermé
/***********************************************************/

void stop() {
  ping.close();
  minim.stop();
  super.stop();
}
