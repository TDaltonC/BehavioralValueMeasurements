function y = equation2Item(p, x) 

numberObs = length(x); 
itemL = x(:,1); % item1, LEFT side of screen
itemR = x(:,2); % item2, RIGHT side of screen

probFcn = zeros(numberObs,1); 

% We multiply the PDF of the logit model (here, "probFcn") by -1 because
% fmincon minimizes instead of maximizing. By minimizing the negative of
% the PDF we are essentially maximizing
for n = 1:numberObs
    probFcn(n) = (-1)*(...
        (x(n,3))*(log(1/(1 + exp(p(itemL(n)) -p(itemR(n)))))) + ...
        (1-x(n,3))*(log(1 - (1/(1 + exp(p(itemL(n)) -p(itemR(n)))))))...
        );
end

y = sum(probFcn(1:numberObs));

end

