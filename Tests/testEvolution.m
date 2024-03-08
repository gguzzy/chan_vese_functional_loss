%% Caricamento script 
clc; close all; clear all;
% Aggiungi le directory che contengono gli script necessari al percorso di MATLAB
addpath(genpath('/MATLAB Drive/matlab_image_segmentation/Evolution'));

%% Inizio Evoluzione Chan-Vese
% Carichiamo immagine digitale
imagePath = '/MATLAB Drive/matlab_image_segmentation/dataset/cell.png';
image = imread(imagePath);

% Controllo immagine grey
if size(image, 3) > 1
    image = rgb2gray(image); % Converti in scala di grigi se necessario
end

% Parametri iniziali per la funzione di insieme di livello
params.centerX = size(image, 2) / 2;
params.centerY = size(image, 1) / 2;
params.radius = min(size(image)) / 4; % Ad esempio, usa un quarto della dimensione minore dell'immagine come raggio
params.a = params.radius; % per ellisse
params.b = params.radius; % per ellisse

% Inizializzazione della funzione di insieme di livello
phi = initializeLevelSet(size(image), 'circle', params);

% Visualizzazione dell'immagine originale e del contorno iniziale di phi
figure;
imshow(image, []);
hold on;
% Assicurati che phi non contenga NaN prima di chiamare la funzione contour
if all(~isnan(phi), 'all')
    contour(phi, [0, 0], 'r', 'LineWidth', 2); % Disegna il contorno di livello zero di phi in rosso
else
    error('La matrice phi contiene NaN.');
end
hold off;
title('Immagine Originale con Contorno di Livello Set Iniziale');

% Parametri per l'evoluzione del modello
lambda1 = 1;
lambda2 = 1;
mu = 0.1; % Coefficiente di lunghezza del contorno
epsilon = 1; % parametro di regolarizzazione
deltaX = 1; % assumiamo che l'immagine abbia spaziatura uniforme
deltaY = 1;
deltaT = 0.1; % time step
maxIter = 500; % Numero massimo di iterazioni

% Evoluzione del Level Set
phi = evolveLevelSet(phi, double(image), lambda1, lambda2, mu, epsilon, deltaX, deltaY, deltaT, maxIter);

% Visualizzazione del risultato finale
figure;
subplot(1,2,1); imshow(image, []); % title('Original segmented image in grey scale');
hold on;
contour(phi, [0, 0], 'r'); % Draw the zero-level contour of the level set function in red
hold off;
saveas(gcf, '/MATLAB Drive/matlab_image_segmentation/Results/immagine_segmentata_con_mask_grey.png');
subplot(1,2,2); imshow(phi >= 0, []); % title('Generated segmented mask');
saveas(gcf, '/MATLAB Drive/matlab_image_segmentation/Results/segmentation_mask_grey.png');

