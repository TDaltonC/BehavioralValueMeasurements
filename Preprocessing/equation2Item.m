function y = equation2Item(p, x) 
% 
% beta1=p(1); beta2=p(2); beta3=p(3); beta4=p(4); beta5=p(5); beta6=p(6); beta7=p(7); beta8=p(8); beta9=p(9); beta10=p(10);
% beta11=p(11); beta12=p(12); beta13=p(13); beta14=p(14); beta15=p(15); beta16=p(16); beta17=p(17); beta18=p(18); beta19=p(19); beta20=p(20);
% beta21=p(21); beta22=p(22); beta23=p(23); beta24=p(24); beta25=p(25); beta26=p(26); beta27=p(27); beta28=p(28); beta29=p(29); beta30=p(30);
% beta31=p(31); beta32=p(32); beta33=p(33); beta34=p(34); beta35=p(35); beta36=p(36); beta37=p(37); beta38=p(38); beta39=p(39); beta40=p(40);
% beta41=p(41); beta42=p(42); beta43=p(43); beta44=p(44); beta45=p(45); beta46=p(46); beta47=p(47); beta48=p(48); beta49=p(49); beta50=p(50);
% beta51=p(51); beta52=p(52); beta53=p(53); beta54=p(54); beta55=p(55); beta56=p(56); beta57=p(57);

numberObs = length(x); 
itemL = x(:,1); % item1, LEFT side of screen
itemR = x(:,2); % item2, RIGHT side of screen

probFcn = zeros(numberObs,1); 

% We multiply the PDF of the logit model (here, "probFcn") by -1 because
% fmincon minimizes instead of maximizing. By minimizing the negative of
% the PDF we are essentially maximizing
for n = 1:numberObs 
probFcn(n) = (-1)*((x(n,3))*(log(1/(1 + exp(-p(itemL(n))*(itemL(n)) -p(itemR(n))*(itemR(n)))))) + ...
        (1-x(n,3))*(log(1 - (1/(1 + exp(-p(itemL(n))*(itemL(n)) -p(itemR(n))*(itemR(n))))))));
end

y = sum(probFcn(1:numberObs));

end

