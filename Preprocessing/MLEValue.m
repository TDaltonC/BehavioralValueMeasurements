function [ cost_output,cost_max,value_output,bestValue,bestLL] = MLEValue(optionL,optionR,choices,limit_lower,limit_upper,sumValuesMatrix,sumValues)
% This fuction estimates the value of a bunch oc options based on subject
% choices. It ercursivly calls a sub function to evaluate the quility of
% the fit. 

%% INPUTS:
% optionL - Option codes for the LEFT option in each choice (vector)
% optionR - Option codes for the RIGHT option in each choice (vector)
% choices - Which option was chosen?
% limit_lower(optional) - Lower limit for the value of options
% limit_upper(optional) - Upper limit for the value of options
% sumValuesMatrix(optional) - limit for the sum of values of all of the options
% sumValues(optional) - I'm not sure, it should probably be the same as sumValuesMatrix

%% OUTPUTS:
% cost_output - 
% cost_max -
% value_output -
% bestValue - 
% bestLL -

%% Defaults and vectorizing 
% If an input is not provided, then we make it an empty array, if one is 
% provided, we vectorize it as needed. 
options = optimset('Algorithm','interior-point');
options.MaxFunEvals = 100000;

optCount = length(unique([optionL,optionR]));

if exist('limit_lower','var') == 0; 
    limit_lower = [];
elseif isempty(limit_lower);
else
    limit_lower = limit_lower*ones(1,optCount);
end

if exist('limit_upper','var') == 0;
    limit_upper = [];
elseif isempty(limit_upper);
else
    limit_upper = limit_upper*ones(1,optCount);
end

if exist('sumValuesMatrix','var') == 0;
    sumValuesMatrix = [];
elseif isempty(sumValuesMatrix);
else
    sumValuesMatrix = sumValuesMatrix*ones(1,optCount);
end

if exist('sumValues','var') == 0;
    sumValues = [];
end




%% Dalton's a doo-doo head and coded the chioces the wrong way
%  He coded them so that 1 <- chose L and 2 <- chose R
%  It should be 1 <- chose L and 0 <- chose R
%  This line fixes that
choices = abs(choices - 2);


%% Lower bound, upper bound, sum restriction
value_initial(1:optCount,1) = 0.1; % initial values for all options
[value_fit,cost_val] = fmincon(@(value) MLECost(value, optionL, optionR, choices), value_initial,[],[],sumValuesMatrix,sumValues,limit_lower,limit_upper,[],options);
value_output = value_fit;
cost_output = cost_val;

%% Saving
cost_max = min(cost_output);
b = find(cost_output == min(cost_output));
c = min(b);
bestValue = value_output(c,:);
bestLL = cost_max;

resultsMLE.cost_output = cost_output;
resultsMLE.cost_max = cost_max;
resultsMLE.value_output = value_output;
resultsMLE.bestValue = bestValue;
resultsMLE.bestLL = bestLL;

save('resultsMLE.mat','resultsMLE');
end

function cost = MLECost(value, optionL, optionR, choices) 
% 
% beta1=value(1); beta2=value(2); beta3=value(3); beta4=value(4); beta5=value(5); beta6=value(6); beta7=value(7); beta8=value(8); beta9=value(9); beta10=value(10);
% beta11=value(11); beta12=value(12); beta13=value(13); beta14=value(14); beta15=value(15); beta16=value(16); beta17=value(17); beta18=value(18); beta19=value(19); beta20=value(20);
% beta21=value(21); beta22=value(22); beta23=value(23); beta24=value(24); beta25=value(25); beta26=value(26); beta27=value(27); beta28=value(28); beta29=value(29); beta30=value(30);
% beta31=value(31); beta32=value(32); beta33=value(33); beta34=value(34); beta35=value(35); beta36=value(36); beta37=value(37); beta38=value(38); beta39=value(39); beta40=value(40);
% beta41=value(41); beta42=value(42); beta43=value(43); beta44=value(44); beta45=value(45); beta46=value(46); beta47=value(47); beta48=value(48); beta49=value(49); beta50=value(50);
% beta51=value(51); beta52=value(52); beta53=value(53); beta54=value(54); beta55=value(55); beta56=value(56); beta57=value(57);

numberObs = length(choices); 

probFcn = zeros(numberObs,1); 

% We multiply the PDF of the logit model (here, "probFcn") by -1 because
% fmincon minimizes instead of maximizing. By minimizing the negative of
% the PDF we are essentially maximizing
for n = 1:numberObs 
probFcn(n) = (-1)*(choices(n)*(log(1/(1 + exp(-value(optionL(n))*(optionL(n)) -value(optionR(n))*(optionR(n)))))) + ...
        (1-choices(n))*(log(1 - (1/(1 + exp(-value(optionL(n))*(optionL(n)) -value(optionR(n))*(optionR(n))))))));
end

cost = sum(probFcn(1:numberObs));

end


