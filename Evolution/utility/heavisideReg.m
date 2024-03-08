% Funzione Heaviside regolarizzata
function H = heavisideReg(x, epsilon)
    H = 0.5 * (1 + (2/pi) * atan(x / epsilon));
end