function [ output_args ] = RunGARPSubject( subjID, allItems, neighborAmt, runs, blockLength, w, input)
%Edited by: Spencer Brown 2015 spencelb@usc.edu

%*******Function Args*******
%subjID - the id of the current subject
%allItems - an array containing all the objects that can be used. The array
%           size is variable
%neighborAmt - the number of neighbors to test the items against i.e. every
%               fifth neighbor
%runs - how many times to run through the arrays
%w - I think this is the frame
%input - tells you if the subject will be using a keyboard('k'), a mouse ('m'), or a windows 8 tablet('t')
%***********f****************

%% Defaults
% Default for subjID is 1. This only kicks in if no subject ID is given.
if exist('subjID','var') == 0;
    subjID = 1;
end
if exist('allItems','var') == 0;
    allItems = {};
    allItems{1} = 1;
    allItems{2} = [2,3]; 
    allItems{3} = 1;
    allItems{4} = [2,3];

end

if exist('neightborAmt','var') == 0;
    neighborAmt = 3;
end
if exist('runs','var') == 0;
    runs = 2;
end
if exist('blockLength','var') == 0;
   blockLength = 38;
end
if exist('input','var') == 0;
    input = 'k'; %keyboard
    Screen('Preference', 'SkipSyncTests', 1 );
end
if input == 't'; % on a tablet we need to disable the screen synch test becuase . . .  who knows
    Screen('preference', 'SkipSyncTests',1);
end
%rng(subjID);

%% **Create the pairs
%set the item to new variable
initItems = allItems;
initLength = numel(initItems);
%determine the new array length
pairedLength = (initLength * neighborAmt)-((neighborAmt * (neighborAmt + 1))/2);
%create the new array
pairedIndex = 1;

%iterate through all the items in initItems
for i = 1: initLength
    for n = 1: neighborAmt
        if i+n <= initLength
            tempArray = {};
            tempArray{1,1} = initItems{i};
            tempArray{1,2} = initItems(i+n);
            pairedArray{pairedIndex} = {tempArray};
            pairedIndex = pairedIndex + 1;
        end
    end
end


%% **Create all the trials and trial order**
allTrialsLength = pairedLength * runs; %The total number of trials that will be performed

%add the paired array as many times as there are runs
allTrialsIndex = 1;
for i = 1: runs
    for n = 1: pairedLength
        allTrialsArray{allTrialsIndex} = pairedArray{n};
        allTrialsIndex = allTrialsIndex + 1;
    end
end

%Trial order
trialOrder = randperm(allTrialsLength);
%Block Length
rewardTrial = randi(blockLength);


%Add the new array in random order
for i = 1: allTrialsLength
    orderedTrialsArray{i} = allTrialsArray{trialOrder(i)};
end

%Invert left and right
%Some times the "LEFT" basket should show up on the right so that the
%suject doesn't get used to seeing the "best" basket on one side of the
%other. flipLR determins when this flipping happens
switchLR = [zeros(1,ceil(allTrialsLength/2)), ones(1,floor(allTrialsLength/2))]; 
switchLR = switchLR(randperm(allTrialsLength));

%Invert top and bottom
%Flip the item that's one top and the item that's on bottom
switchTop = [zeros(1,ceil(allTrialsLength/2)), ones(1,floor(allTrialsLength/2))]; 
switchTop = switchTop(randperm(allTrialsLength));
switchBottom = [zeros(1,ceil(allTrialsLength/2)), ones(1,floor(allTrialsLength/2))]; 
switchBottom = switchBottom(randperm(allTrialsLength));
switchTB = cat(1, switchTop, switchBottom);

%% Set up the screen

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);
if exist('w','var') == 0;
    w = Screen('OpenWindow', screenNumber,[],[],[],[]);
end
%% Saving the settings

settings.recordfolder       = 'records';
settings.subjID             = subjID;
settings.switchLR           = switchLR; %if '0', don't flip. If '1' flip the left basker for the right basket
settings.switchTB           = switchTB; %if '0', don't flip. If '1' the order of the basket
settings.neighbors          = neighborAmt;
settings.runs               = runs;
settings.taskCombiniations  = pairedArray; 
settings.taskOrder          = trialOrder;
settings.taskAll            = orderedTrialsArray;
settings.blockLength        = blockLength;

settings.screenNumber       = screenNumber;
settings.width              = width;
settings.height             = height;

% if the records folder doesn't exist, create it.
if settings.recordfolder
    mkdir(settings.recordfolder);
end
% creat the file name for this run of this subject
recordname = [settings.recordfolder '/' num2str(subjID) '_' datestr(now,'yyyymmddTHHMMSS') '.mat'];
% Save the settings (the results are saved later)
save (recordname, 'settings');
% Restrict the keys that can be used for the Kb commands [ALL KEYS ARE
% ENABLED AFTER A cear all command]
if (ismac)
            RestrictKeysForKbCheck([9, 13, 41]) %These are the Mac key codes for f, j, and ESCSAPE respectively
            escKey = KbName('ESCAPE');
        else
            RestrictKeysForKbCheck([70, 74, 81]) %THese are the PC keys for f, j and q
            escKey = KbName('Esc');
end
 
%% Visuals start
% Display "READY"
drawStart(w);
Screen('Flip',w);
WaitSecs(10);
if input == 'k';
    KbWait([], 3);
elseif input == 'm';
    GetClicks(w,0);
elseif input == 't';
    SetMouse(width/2, height/2 ,w);
    while true;
        [x,y] = GetMouse(w);
        if x ~= width/2 && y ~= height/2;
            break;
        end
    end
end

%% during the experiment
% Be mindfull that only the "behavioral." data structure will be saved.

% Set all of the indexs equal to 1
trialIndex = 1;
block = 1;


while trialIndex <= allTrialsLength;
    %%For all the first group of items load the images into an array
    
    itemsLeft = {};
    %trial = orderedTrialsArray{trialIndex}{1};
    %left = orderedTrialsArray{trialIndex}{1}{1};
    %%if there is only one item on the side, then the other box is grey
    if numel(orderedTrialsArray{trialIndex}{1}{1}) < 2
        firstItem = imread(strcat('Image', num2str(orderedTrialsArray{trialIndex}{1}{1}(1)), '.JPG'));
        secondItem = imread('grey.jpg');
    else
        firstItem = imread(strcat('Image', num2str(orderedTrialsArray{trialIndex}{1}{1}(1)), '.JPG'));
        secondItem = imread(strcat('Image', num2str(orderedTrialsArray{trialIndex}{1}{1}(2)), '.JPG'));
    end
    %Switch the top and the bottom
    if switchTB(1, trialIndex) == 0
        itemsLeft{1} = firstItem;
        itemsLeft{2} = secondItem;
    else
        itemsLeft{1} = secondItem;
        itemsLeft{2} = firstItem;
    end
    
    itemsRight = {};
    %trial = orderedTrialsArray{trialIndex}{1};
    %right = orderedTrialsArray{trialIndex}{1}{2}{1};
    %%if there is only one item on the side, then the other box is grey
    test = orderedTrialsArray{trialIndex}{1}{2}{1}(1);
    numb = numel(orderedTrialsArray{trialIndex}{1}{2});
    if numel(orderedTrialsArray{trialIndex}{1}{2}{1}) < 2
        firstItem = imread(strcat('Image', num2str(orderedTrialsArray{trialIndex}{1}{2}{1}(1)), '.JPG'));
        secondItem = imread('grey.jpg');
    else
        firstItem = imread(strcat('Image', num2str(orderedTrialsArray{trialIndex}{1}{2}{1}(1)), '.JPG'));
        secondItem = imread(strcat('Image', num2str(orderedTrialsArray{trialIndex}{1}{2}{1}(2)), '.JPG'));
    end
    
    if switchTB(2,trialIndex) == 0
        itemsRight{1} = firstItem;
        itemsRight{2} = secondItem;
    else
        itemsRight{1} = secondItem;
        itemsRight{2} = firstItem;
    end
    
    %%Switch left and right side
    if switchLR(trialIndex) == 0;
        renderGARP(itemsLeft, itemsRight,0,w);
    elseif switchLR(trialIndex) == 1;
        renderGARP(itemsLeft, itemsRight,1,w);
    end
    
    % Draw aka "flip"   
    % wait till the time is right  ------ Then flip

    if trialIndex > 1; % So don't wait on the first lap through
    % first wiat .2 secons so that they have time to stop pressing the button.
        WaitSecs(0.25);
    end
    Screen('Flip',w);

    if input  == 'k';% 'k' for for Keyboard
        [behavioral.secs(trialIndex,1), keyCode, behavioral.deltaSecs] = KbWait([], 3);

        %drawFixation
        drawFixation(w);

        %If a key is pressed, record that key press in the behavioral record.
        if sum(keyCode) == 1;
            behavioral.key(trialIndex,1) = KbName(keyCode);
        end
    elseif input == 'm'; % 'm' is for mouse
        [clicks,x,y,whichButton] = GetClicks(w,0);

        %drawFixation
        drawFixation(w);

        %Record where the click happened and which side it was on
        if x <= width/2;
            behavioral.key(trialIndex,1) = 'f'; 
        elseif x > width/2;
            behavioral.key(trialIndex,1) = 'j';
        end
    elseif input == 't'; % 't' is for tablet
        SetMouse(width/2, height/2 ,w);
        while true;
            [x,y] = GetMouse(w);
            if x ~= width/2 && y ~= height/2;
                break;
            end
        end
        behavioral.secs(trialIndex,1) = now;
        %drawFixation
        drawFixation(w);

        if x <= width/2;
            behavioral.key(trialIndex,1) = 'f'; 
        elseif x > width/2
            behavioral.key(trialIndex,1) = 'j';
        end

    end

%%STILL IN THE WHILE LOOP
%% All of this is just of outputting the reward
        if trialIndex == rewardTrial;
            left.Item  = orderedTrialsArray{trialIndex}{1}{1};
            right.Item = orderedTrialsArray{trialIndex}{1}{2}{1};
        if behavioral.key(trialIndex) == 'f';
            if switchLR(trialIndex) == 0; %%if the display was flipped, this conditional flips the reward
                reward.Item   = left.Item;
                reward.Not    = right.Item;
            elseif switchLR(trialIndex) == 1;
                reward.Item   = right.Item;
                reward.Not    = left.Item;
            end
        elseif behavioral.key(trialIndex) == 'j';
            if switchLR(trialIndex) == 0;
                reward.Item   = right.Item;
                reward.Not    = left.Item;
            elseif switchLR(trialIndex) == 1;
                reward.Item   = left.Item;
                reward.Not    = right.Item;
            end
        end
        rewardrecordname = [settings.recordfolder '/' 'reward_' num2str(subjID) '_' datestr(now,'yyyymmddTHHMMSS') '.mat'];
        save (rewardrecordname, 'reward');
        end
%%STILL IN WHILL LOOP

    if mod(trialIndex,blockLength) == 0; %This throws up the "break" screen between trials.
        drawBreak(w);
        Screen('Flip',w);
        WaitSecs(20);
        if input == 'k';
            KbWait([], 3);
        elseif input == 'm';
            GetClicks(w,0);
        elseif input == 't';
            SetMouse(width/2, height/2 ,w);
            while true;
                [x,y] = GetMouse(w);
                if x ~= width/2 && y ~= height/2;
                    break;
                end
            end
        end
        block = block + 1;
    end
    
    %%increment the trial order
    trialIndex = trialIndex + 1;
end%%END OF WHILE LOOP
%% at the end
% up at the end of setings we created a file to hold all of our important data
% Now we will save all of the behavioural data in the same -.mat file

save (recordname, 'behavioral', '-append')
drawStop(w);
Screen('Flip',w);
WaitSecs(20);
if input == 'k';
    KbWait([], 3);
elseif input == 'm';
    GetClicks(w,0);
elseif input == 't';
    SetMouse(width/2, height/2 ,w);
    while true;
        [x,y] = GetMouse(w);
        if x ~= width/2 && y ~= height/2;
            break;
        end
    end
end
Screen('CloseAll');
end

