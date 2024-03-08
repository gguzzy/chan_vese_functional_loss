%% Caricamento script 
clc; close all; clear all;
% Aggiungi le directory che contengono gli script necessari al percorso di MATLAB
addpath(genpath('/MATLAB Drive/matlab_image_segmentation/Evolution'));

%% Inizio Evoluzione Chan-Vese
% Carichiamo immagine digitale
imagePath = '/MATLAB Drive/matlab_image_segmentation/dataset/cell.png';
imageRGB = imread(imagePath);

% % Controllo immagine grey
% if size(image_rgb, 3) > 1
%     image_rgb = rgb2gray(image_rgb); % Converti in scala di grigi se necessario
% end

% Inizializzazione della funzione di insieme di livello comune
params.centerX = size(imageRGB, 2) / 2;
params.centerY = size(imageRGB, 1) / 2;
params.radius = min(size(imageRGB, 1), size(imageRGB, 2)) / 4;
phi = initializeLevelSet([size(imageRGB, 1), size(imageRGB, 2)], 'circle', params);

% Visualizzazione dell'immagine originale e del contorno iniziale di phi
figure;
imshow(imageRGB, []);
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

segmentationResults = zeros([size(phi), 3]);

% Evoluzione del Level Set
% phi = evolveLevelSet(phi, double(image_rgb), lambda1, lambda2, mu, epsilon, deltaX, deltaY, deltaT, maxIter);

for channel = 1:3
    % Estrai il singolo canale
    imageChannel = double(imageRGB(:,:,channel));
    
    % Evoluzione del Level Set per il canale corrente
    phiChannel = evolveLevelSet(phi, imageChannel, lambda1, lambda2, mu, epsilon, deltaX, deltaY, deltaT, maxIter);
    
    % Memorizza il risultato della segmentazione per il canale corrente
    segmentationResults(:,:,channel) = phiChannel >= 0;

    % Crea una nuova figura per ciascun canale
    fig = figure;
    imshow(segmentationResults(:,:,channel), []);
    title(['Segmentazione Canale ', num2str(channel)]); % Usa num2str per convertire il numero del canale in stringa
    
    % Salva la figura utilizzando un nome file che include il numero del canale
    saveas(fig, ['/MATLAB Drive/matlab_image_segmentation/Results/segmentation_result_channel_', num2str(channel), '.svg']);
    
    % Chiudi la figura dopo averla salvata per evitare sovrapposizioni grafiche
    close(fig);
end

%% AGGREGAZIONE DEI VARI CANALI RGB
% Aggrega i risultati della segmentazione
%% OR LOGICAL
finalSegmentation = any(segmentationResults, 3);

% Visualizzazione del risultato finale
figure;
subplot(1,2,1); imshow(imageRGB, []); title('Initial original image');


hold on;
contour(phi, [0, 0], 'r'); % Draw the zero-level contour of the level set function in red
hold off;
saveas(gcf, '/MATLAB Drive/matlab_image_segmentation/Results/immagine_segmentata_risultato_RGB.svg');
% subplot(1,2,2); imshow(phi >= 0, []); title('Segmentazione');
subplot(1,2,2); imshow(finalSegmentation, []); title('Segmented using aggregator OR');
saveas(gcf, '/MATLAB Drive/matlab_image_segmentation/Results/segmentation_result_RGB_OR.svg');

%% AND LOGICAL
% Aggrega i risultati della segmentazione utilizzando l'operazione logica AND
finalSegmentationAND = all(segmentationResults, 3);

% Visualizzazione del risultato finale con AND
figure;
subplot(1,2,1); imshow(imageRGB, []); title('Initial original image');
subplot(1,2,2); imshow(finalSegmentationAND, []); title('Segmented using aggregator AND');
saveas(gcf, '/MATLAB Drive/matlab_image_segmentation/Results/segmentation_result_AND.svg');

%% VOTO MAGGIORANZA
% Calcola il voto di maggioranza per ogni pixel
votes = sum(segmentationResults, 3);
finalSegmentationMajorityVote = votes > 1; % Un pixel è segmentato se almeno 2 canali su 3 lo indicano

% Visualizzazione del risultato finale con Voto di Maggioranza
figure;
subplot(1,2,1); imshow(imageRGB, []); title('Initial original image');
subplot(1,2,2); imshow(finalSegmentationMajorityVote, []); title('Segmented Majority Vote');
saveas(gcf, '/MATLAB Drive/matlab_image_segmentation/Results/segmentation_result_MajorityVote.svg');
