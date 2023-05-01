clear all;
format long;
%% Ce fichier permet de générer le graphe de la réponse à la question 14.
% C'est-a-dire il trace toutes les valeurs propres des différents types de
% matrice.
%%%%%%%%%%%%
% PARAMÈTRES
%%%%%%%%%%%%

% taille de la matrice symétrique
n = 500;

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;

% on génère la matrice (1) ou on lit dans un fichier (0)
genere = 0;

% méthode de calcul
v = 10; % subspace iteration v0

% nombre de valeurs propres cherchées (v0)
m = 20;
figure(1);
subplot(121);
imat = 1;
[W, V, flag] = eigen_2021(imat, n, v, m, eps, maxit, [], [], genere);
plot(W);
title("Vp des matrices de type 1 dans l'ordre décroissant");

subplot(122);
for i = 2:4
% type de la matrice (voir matgen_csad)
% imat == 1 valeurs propres D(i) = i
% imat == 2 valeurs propres D(i) = random(1/cond, 1) avec leur logarithmes
%                                  uniformément répartie, cond = 1e10
% imat == 3 valeurs propres D(i) = cond**(-(i-1)/(n-1)) avec cond = 1e5
% imat == 4 valeurs propres D(i) = 1 - ((i-1)/(n-1))*(1 - 1/cond) avec cond = 1e2
    imat = i;

    [W, V, flag] = eigen_2021(imat, n, v, m, eps, maxit, [], [], genere);
    plot(W);
    hold on
end
title("Vp des matrices de type 2, 3 et 4 dans l'ordre décroissant");
legend("matrice type 2", "matrice type 3", "matrice type 4")