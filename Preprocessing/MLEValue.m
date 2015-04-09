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
options.MaxFunEvals = 1000000;


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


numberObs = length(choices); 

probFcn = zeros(numberObs,1); 

% We multiply the PDF of the logit model (here, "probFcn") by -1 because
% fmincon minimizes instead of maximizing. By minimizing the negative of
% the PDF we are essentially maximizing
for n = 1:numberObs 
probFcn(n) = (-1)*(choices(n)* (log(     1/(1 + exp(value(optionL(n))*(1) -value(optionR(n))*(1))))) + ...
                  (1-choices(n))*(log(1 - (1/(1 + exp(value(optionL(n))*(1) -value(optionR(n))*(1)))))));
end

cost = sum(probFcn(1:numberObs));

end


function stop = outfun(x,optimValues,state)
stop = false;
 
   switch state
       case 'init'
           hold on
       case 'iter'
           % Concatenate current point and objective function
           % value with history. x must be a row vector.
           history.fval = [history.fval; optimValues.fval];
           history.x = [history.x; x];
           % Concatenate current search direction with 
%            % searchdir.
%            searchdir = [searchdir;...
%                         optimValues.searchdirection'];
           plot(x(1),x(2),'o');
           % Label points with iteration number.
           % Add .15 to x(1) to separate label from plotted 'o'
           text(x(1)+.15,x(2),num2str(optimValues.iteration));
       case 'done'
           hold off
       otherwise
   end
end

