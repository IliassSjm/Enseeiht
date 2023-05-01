#ifndef _PROCESSUS
#define _PROCESSUS
#include <stdbool.h>
#include <stdio.h>
#include <sys/types.h> 
#include <unistd.h> 
/* Type Etat du processus*/
typedef enum{ACTIF,SUSPENDU} Etat;

/* Type liste chainee */
typedef struct processus *List;

#endif
/* Initialiser une liste de processus */
List new_liste_proc();


//On vérifie si un processus appartient au liste 
bool exiteProcessus(List *liste,pid_t pid_processus); 

/* Supprimer un processus d'une liste de processus, 
/*  reconnu à partir de son pid */
void delete_proc(List *liste_processus, pid_t pid);

/* Obtenir la taille d'une Liste */
int tailleListe (List **liste_proc);


/* Afficher une liste de processus */
void afficher(List *l);



