function phi = evolveLevelSet(phi, image, lambda1, lambda2, mu, epsilon, deltaX, deltaY, deltaT, maxIter)
% Evolve la funzione di insieme di livello seguendo le equazioni fornite.
% phi: Funzione di insieme di livello iniziale.
% image: Immagine da segmentare.
% lambda1, lambda2, mu: Parametri del modello.
% epsilon: Parametro per la regolarizzazione di Heaviside e Dirac.
% deltaX, deltaY: Dimensione del passo spaziale.
% deltaT: Dimensione del passo temporale.
% maxIter: Numero massimo di iterazioni.

for iter = 1:maxIter
    % Calcola derivati
    % phi_x = (circshift(phi, [-1, 0]) - circshift(phi, [1, 0])) / (2*deltaX);
    % phi_y = (circshift(phi, [0, -1]) - circshift(phi, [0, 1])) / (2*deltaY);
    % phi_xx = (circshift(phi, [-1, 0]) - 2*phi + circshift(phi, [1, 0])) / deltaX^2;
    % phi_yy = (circshift(phi, [0, -1]) - 2*phi + circshift(phi, [0, 1])) / deltaY^2;
    % phi_xy = (circshift(circshift(phi, [-1, 0]), [0, -1]) + circshift(circshift(phi, [1, 0]), [0, 1]) ...
    %           - circshift(circshift(phi, [-1, 0]), [0, 1]) - circshift(circshift(phi, [1, 0]), [0, -1])) / (4*deltaX*deltaY);
    % 
    % % Calcola curvatura
    % curvature = (phi_xx .* phi_y.^2 - 2 .* phi_xy .* phi_x .* phi_y + phi_yy .* phi_x.^2) ./ ...
    %             (phi_x.^2 + phi_y.^2).^(3/2);
    for iter = 1:maxIter
    % Calcola derivati con una regolarizzazione per prevenire divisione per zero
    phi_x = (circshift(phi, [-1, 0]) - circshift(phi, [1, 0])) / (2*deltaX);
    phi_y = (circshift(phi, [0, -1]) - circshift(phi, [0, 1])) / (2*deltaY);
    phi_xx = (circshift(phi, [-1, 0]) - 2*phi + circshift(phi, [1, 0])) / deltaX^2;
    phi_yy = (circshift(phi, [0, -1]) - 2*phi + circshift(phi, [0, 1])) / deltaY^2;
    phi_xy = (circshift(circshift(phi, [-1, 0]), [0, -1]) + circshift(circshift(phi, [1, 0]), [0, 1]) ...
              - circshift(circshift(phi, [-1, 0]), [0, 1]) - circshift(circshift(phi, [1, 0]), [0, -1])) / (4*deltaX*deltaY);
              
    denom = (phi_x.^2 + phi_y.^2).^(3/2) + epsilon; % Aggiungi epsilon per prevenire divisione per zero
    curvature = (phi_xx .* phi_y.^2 - 2 .* phi_xy .* phi_x .* phi_y + phi_yy .* phi_x.^2) ./ denom;

    % Calcola delta epsilon
    deltaEpsilon = epsilon ./ (pi * (epsilon^2 + phi.^2));
    
    % Intensità medie INSIDE e OUTSIDE C
     inside_mask = heavisideReg(phi, epsilon);
    outside_mask = 1 - inside_mask;
    
    c1 = sum(sum(inside_mask .* image)) / sum(inside_mask(:));
    c2 = sum(sum(outside_mask .* image)) / sum(outside_mask(:));
    
    phi = phi + deltaT .* deltaEpsilon .* (mu * curvature - lambda1 * (image - c1).^2 + lambda2 * (image - c2).^2);
    
    % Condizione di arresto (opzionale)
    if iter > 1 && max(abs(phi(:) - phi_old(:))) < deltaT
        break;
    end

    % Verifica NaN prima dell'assegnazione a phi_old e potenzialmente interrompi l'esecuzione
    if any(isnan(phi(:)))
        warning('NaN detected, stopping iteration.');
        break;
    end
    
    phi_old = phi;
end
end
