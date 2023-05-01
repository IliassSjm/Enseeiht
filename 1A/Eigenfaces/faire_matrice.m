clear all;
format long;
%% Ce fichier permet de générer toutes les matrices de chaque type en suivant les dimensions précisées dans N
% on génère la matrice (1) ou on lit dans un fichier (0)
genere = 1;

% Dimensions des matrices à générer
N = 50:50:1000;

for i = 1:4
    % type de la matrice (voir matgen_csad)
    % imat == 1 valeurs propres D(i) = i
    % imat == 2 valeurs propres D(i) = random(1/cond, 1) avec leur logarithmes
    %                                  uniformément répartie, cond = 1e10
    % imat == 3 valeurs propres D(i) = cond**(-(i-1)/(n-1)) avec cond = 1e5
    % imat == 4 valeurs propres D(i) = 1 - ((i-1)/(n-1))*(1 - 1/cond) avec cond = 1e2
    imat = i;
    for taille = 1:20
        n = N(taille);
        [W, V, flag] = eigen_2021(imat, n, 10, [], [], [], [], [], genere);
    end
end
