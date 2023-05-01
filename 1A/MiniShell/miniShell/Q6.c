#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "readcmd.h"
#include "readcmd.c"
#include <sys/wait.h>
#include "liste.h"
#include <signal.h>
#include "liste.c"

List *liste;
/*processus courant.*/
pid_t processus_actuel=0;
/*ctrl+z*/
bool ctrl_z=false;
/*ctrl+c.*/
bool ctrl_c=false;


/*la commande fg*/
void fg(struct cmdline *commande){
     if (!(commande->seq[0][1] == NULL)){
              pid_t PID = atoi(commande->seq[0][1]);
              if (exiteProcessus(liste,PID)) { 
			          ctrl_z=false;
		              ctrl_c=false;
               /* Envoyer le signal Reprise au processus demandée. */
                       kill(PID,SIGCONT);
                       processus_actuel = PID;
				        /*On attend jusqu'à la fin de processus en avant plan, et 
				         ce traitement continue, tant qu'on a pas tapé ctrl_c
			                 ou ctrl_z.*/
                                while((processus_actuel==PID) && !(ctrl_z) && !(ctrl_c)){                   
                                    sleep(0);
                                }  
                        } else {
                            printf( "Le processus de  PID %d est introuvable. \n" ,PID);
                        }
                    } else {
                        printf( "Vous devez entrer le PID de processus\n" );
                    }
                    processus_actuel = 0;

            }
void bg(struct cmdline *commande){
       if (!(commande->seq[0][1] == NULL)){
             pid_t PID = atoi(commande->seq[0][1]);
             if (exiteProcessus(liste,PID)) { 
                /* Envoyer le signal Reprise au processus demandée. */
                 kill(PID,SIGCONT);   
     		         } else {
                            printf( "Le processus de  PID %d est introuvable. \n" ,PID);
                        }
                    } 
        else {
             printf( "Vous devez entrer le PID de processus\n" );
             }
       processus_actuel = 0;
 

                  


int main() {
    List *liste;
    liste= malloc(500);
    //List liste = new_liste_proc(); // Liste contenant tous les processus
    pid_t fils; // Processus fils 
    while (1){
    struct cmdline *commande;
     /* Lire la commande. */
      do {
        commande = readcmd();
         } while (commande->seq[0] == NULL);
        if (!(commande->seq[0] == NULL)){
            
              /* La commande exit.*/
               if (!strcmp(commande->seq[0][0],"exit")) {
                       exit(0);  
            } 
              /* La commande cd. */
               else if (!strcmp(commande->seq[0][0],"cd")) {
                       if((commande->seq)[0][1]==NULL || strcmp((commande->seq)[0][0], "~")==0) {
                            chdir("/");
                }      else {
                             chdir(commande->seq[0][1]);
                            }
              }else if (strcmp(commande->seq[0][0], "stop") == 0 ) {
                pid_t pid = atoi(commande->seq[0][1]);
                kill (pid, SIGSTOP);
            // commande fg
            }  else if (!strcmp(commande->seq[0][0], "fg")) {
                fg(commande);
                 // commande bg
            } else if (!strcmp(commande->seq[0][0],"bg")){
                        bg(commande);
            } else if (strcmp(commande->seq[0][0], "jobs") == 0 ) {
                        afficher(liste);
            }

 
         }
      fils = fork();
   // Si le fork échoue
      if ( fils < 0 ) {
         printf("Erreur fork failed\n");
         exit(1); 
   // SI le fork fonctionne 
    } else if (fils ==0) { 
           /* Execution de la commande */
	       execvp(commande ->seq[0][0],commande -> seq[0]);	
           exit(0);

    } else { // Père

      if (commande->backgrounded == NULL) {
           int wstatut;
           waitpid(fils, &wstatut,WUNTRACED);
           if (!WIFSTOPPED(wstatut)) {
                 delete_proc(liste, fils);
            }
         }
  }
        
      
 }
   
}
