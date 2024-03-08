% Funzione Delta di Dirac regolarizzata
function delta = diracReg(x, epsilon)
    delta = (epsilon / pi) ./ (epsilon^2 + x.^2);
end
