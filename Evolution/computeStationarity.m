% Calcolo del termine Q per verificare la stazionarietà
function Q = computeStationarity(phi_old, phi_new, deltaX, deltaT)
    Q = sum(abs(phi_new(:) - phi_old(:)) < (deltaX^2 * deltaT));
end
