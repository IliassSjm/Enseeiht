clear all;
format long;

%% Ce fichier permet de réaliser des tests sur les différents algorithmes en parallèle.
%%%%%%%%%%%%
% PARAMÈTRES
%%%%%%%%%%%%

% type de la matrice (voir matgen_csad)
% imat == 1 valeurs propres D(i) = i
% imat == 2 valeurs propres D(i) = random(1/cond, 1) avec leur logarithmes
%                                  uniformément répartie, cond = 1e10
% imat == 3 valeurs propres D(i) = cond**(-(i-1)/(n-1)) avec cond = 1e5
% imat == 4 valeurs propres D(i) = 1 - ((i-1)/(n-1))*(1 - 1/cond) avec cond = 1e2
imat = 3;

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 10000;
% on génère la matrice (1) ou on lit dans un fichier (0)
genere = 0;

% nombre de valeurs propres cherchées (v0 et power)
m0 = 20;

% taille du sous-espace (V1, v2, v3)
m = 20;

% pourcentage de la trace que l'on veut atteindre (v1, v2, v3)
percentage = .4;
n = 150;

for v = [0 1 2 3 10 11 12]
    switch v
        case 0
            [W, V, flag] = eigen_2021(imat, n, v, m0, eps, maxit, percentage, [], genere);
        case 1
            [W, V, flag] = eigen_2021(imat, n, v, m, eps, maxit, percentage, [], genere);
        case 2
            [W, V, flag] = eigen_2021(imat, n, v, m, eps, maxit, percentage, 20, genere);
        case 3
            [W, V, flag] = eigen_2021(imat, n, v, m, eps, maxit, percentage, 20, genere);
        case 10
            [W, V, flag] = eigen_2021(imat, n, v, [], [], [], [], [], genere);
        case 11
            [W, V, flag] = eigen_2021(imat, n, v, m0, eps, maxit, percentage, [], genere);
        case 12
            [W, V, flag] = eigen_2021(imat, n, v, m0, eps, maxit, percentage, [], genere);
        otherwise
            ok = 1
    end
end
        

