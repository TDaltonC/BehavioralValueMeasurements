cd('/Users/Dalton/Documents/Projects/BundledOptionsExp/BehavioralValueMeasurements')
load('/Users/Dalton/Documents/Projects/BundledOptionsExp/BehavioralValueMeasurements/records/1_20150106T201419.mat')

%% Options DataFame
elicitedRank = 1:numel(settings.allOptions);
for i = elicitedRank
    item1(i) = settings.allOptions{1, i}(1);
    try
        item2(i) = settings.allOptions{1, i}(2);
        itemCount(i) = 2;
        if settings.allOptions{1, i}(2) == settings.allOptions{1, i}(1)
            type(i) = 2;
        else
            type(i) = 3;
        end
    catch
        item2(i) = 0;
        itemCount(i) = 1;
        type(i) = 1;
    end
end
optSID = cell(numel(settings.allOptions),1);
optSID(:) = {settings.subjID};

%% Responses DataFrame

for i = 1:numel(settings.taskAll);
    opt1item1(i) = settings.taskAll{i}{1}{1}(1);
    try
        opt1item2(i) = settings.taskAll{i}{1}{1}(2);
    catch
        opt1item2(i) = 0;
    end
    opt2item1(i) = settings.taskAll{i}{1}{2}{1}(1);
    try
        opt2item2(i) = settings.taskAll{i}{1}{2}{1}(2);
    catch
        opt2item2(i) = 0;
    end
    for rank = elicitedRank 
        if  [item1(rank),item2(rank)] == [opt1item1(i),opt1item2(i)]
            opt1Code(i) = rank;
            break
        end
    end
    for rank = elicitedRank 
        if  [item1(rank),item2(rank)] == [opt2item1(i),opt2item2(i)]
            opt2Code(i) = rank;
            break
        end
    end       
end

switchLR = settings.switchLR;
switchTB1 = settings.switchTB(1,:);
switchTB2 = settings.switchTB(2,:);

choiceLR = behavioral.key;
for i = 1:numel(choiceLR)
    if choiceLR(i) == 'f'
        if switchLR(i) == 0
            chosenOpt(i) = 1;
        elseif switchLR(i) == 1
            chosenOpt(i) = 2;
        end
    elseif choiceLR(i) == 'j'
        if switchLR(i) == 0
            chosenOpt(i) = 2;
        elseif switchLR(i) == 1
            chosenOpt(i) = 1;
        end
    end
end
respSID = cell(numel(settings.taskAll),1);
respSID(:) = {settings.subjID};
reactionTime = behavioral.secs;

%% Estimate Values

[a,b,valueLBUBSUM,d,e] = MLEValue(opt1Code,opt2Code,chosenOpt,0,1,1,1);
[a,b,valueLBUB,d,e]    = MLEValue(opt1Code,opt2Code,chosenOpt,-1,1);
[a,b,valueLB,d,e]      = MLEValue(opt1Code,opt2Code,chosenOpt,0);
[a,b,value,d,e]        = MLEValue(opt1Code,opt2Code,chosenOpt,[],100);

%% Save the two dataframes
cd('records');
options = table(   optSID  ,elicitedRank' ,itemCount' ,type' ,item1' ,item2', valueLBUBSUM,  valueLBUB,  valueLB,  value,...
    'VariableNames',{'SID' 'elicitedRank' 'itemCount' 'type' 'item1' 'item2','valueLBUBSUM','valueLBUB','valueLB','value'});
writetable(options,'options.csv');

responses = table(  [1:length(settings.taskAll)]',  respSID  ,reactionTime  ,opt1item1' ,opt1item2' ,opt2item1' ,opt2item2' ,switchLR' ,switchTB1' ,switchTB2', opt1Code', opt2Code', chosenOpt',...
    'VariableNames',{ 'index',                'respSID' 'reactionTime' 'opt1item1' 'opt1item2' 'opt2item1' 'opt2item2' 'switchLR' 'switchTB1' 'switchTB2' 'opt1Code' 'opt2Code'  'chosenOpt'});
writetable(responses,'responses.csv');


