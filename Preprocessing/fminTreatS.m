function [ y_output,y_max,p_output,bestValue,bestLL] = fminTreatS()
%you need to feed data as two-column vector called 'x'.
%this script will call on a log-likelihood fcn called 'equation.m' that
%will report parameters as variable called 'p_fit'

load('choices.mat');

x = zeros(length(choices),3);

for m = 1:length(choices)
    x(m,1:2) = choices(m,1:2);
end

for m = 1:length(x)
    if choices(m,3) == 1
        x(m,3) = 1;
    elseif choices(m,3) == 2
        x(m,3) = 0;
    end
end

options = optimset('Algorithm','interior-point');
options.MaxFunEvals = 100000;

%% Lower bound, upper bound, sum restriction
% limit_lower = zeros(1,57);
% limit_upper = ones(1,57);
% sumValuesMatrix = ones(1,57);
% sumValues = 1;

% p_initial(1:57,1) = 0.1; % initial values for all options
% [p_fit,y_val] = fmincon(@(p) equation2Item(p, x), p_initial,[],[],sumValuesMatrix,sumValues,limit_lower,limit_upper,[],options);
% p_output = p_fit;
% y_output = y_val;

%% LB, UB, no sum restriction
% limit_lower = zeros(1,57);
% limit_upper = ones(1,57);

% p_initial(1:57,1) = 0.1; % initial values for all options
% [p_fit,y_val] = fmincon(@(p) equation2Item(p, x), p_initial,[],[],[],[],limit_lower,limit_upper,[],options);
% p_output = p_fit;
% y_output = y_val;

%% LB, no UB, no sum restriction
% limit_lower = zeros(1,57);
% 
% p_initial(1:57,1) = 0.1; % initial values for all options
% [p_fit,y_val] = fmincon(@(p) equation2Item(p, x), p_initial,[],[],[],[],limit_lower,[],[],options);
% p_output = p_fit;
% y_output = y_val;

%% No bounds, no sum restriction
limit_upper = 100*ones(1,57);

p_initial(1:57,1) = 0.1; % initial values for all options
[p_fit,y_val] = fmincon(@(p) equation2Item(p, x), p_initial,[],[],[],[],[],limit_upper,[],options);
p_output = p_fit;
y_output = y_val;

%% Saving
y_max = min(y_output);
b = find(y_output == min(y_output));
c = min(b);
bestValue = p_output(c,:);
bestLL = y_max;

resultsMLE.y_output = y_output;
resultsMLE.y_max = y_max;
resultsMLE.p_output = p_output;
resultsMLE.bestValue = bestValue;
resultsMLE.bestLL = bestLL;

save('resultsMLE.mat','resultsMLE');
end



