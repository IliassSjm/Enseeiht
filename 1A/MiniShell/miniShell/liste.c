#include <string.h>
#include "malloc.h"
#include "liste.h"
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/types.h> 

/* Definition du type qui servira de chainon à la liste chainee */
struct processus {
	int idProcessus;
	pid_t pid;
	Etat etat;
	List suivant;
};




/* Initialiser une liste de processus */
List new_liste_proc(){
	return NULL;
}



/*Savoir si un processus appartient au liste à partie son PID.*/
bool exiteProcessus(List *liste,pid_t pid_donnee) {
        int n = 0;
       while (!(liste[n] == NULL)){ 
            n++; }
        bool t=false;
        int i;
        for (i = 0; i < n; i++) {
            if (liste[i]->pid == pid_donnee) {
                t=true;
            }
        }
        return t;
}

/* La taille de la liste des processus.*/
int tailleListe (List **list){
    int i = 0;
    while (!(list[i] == NULL)){ 
            i++;
            }
    return i;
}


/* Supprimer un processus d'une liste de processus */
void delete_proc(List *list, pid_t pid_processus){
	int taille = 0;
    List l = *list;
    while (!(list[taille] == NULL)){ 
            taille++;
            }
    int position = -1;
    int i = 0;
    while(!(list[i] == NULL)) {
        if (l -> pid == pid_processus)   {
              position = i; 
              break;}
           i++;
         }
	 if (!(position == -1)){
        int i;
        for (i = position+1; i < taille ;i++){
            *(list[i-1]) = *(list[i]);
        }
        list[taille-1] = NULL;
        free(list[taille-1]);
        list = calloc(taille-1,sizeof(list));
    }
	
}	
		
/* Afficher une liste de processus */
void afficher(List *l){
	if ( &l == NULL ) {
		printf(" Erreur d'affichage ");
	}
	while (&l != NULL){
		printf(" Processus %d de pid: %d ", (*l)-> idProcessus, (*l)-> pid);
		if ( (*l)-> etat == ACTIF){
			printf("est actif \n");
		}else{
			printf("est suspendu \n");
		}	
		*l = (*l) -> suivant;
	}
}

