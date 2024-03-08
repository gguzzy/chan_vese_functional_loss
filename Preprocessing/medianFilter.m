function [filteredImage] = medianFilter(image, kernelSize)
% Applica un filtro mediano a un'immagine: per contrastare Salt&Pepper
% image: Immagine da filtrare
% kernelSize: Dimensione del kernel del filtro mediano

filteredImage = medfilt2(image, [kernelSize kernelSize]);
end
