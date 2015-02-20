function [ output_args ] = renderGARP( itemsLeft, itemsRight,flip, w )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    screenNumber = max(Screen('Screens'));
    [width height] = Screen('WindowSize', screenNumber);
    
    
     
    
    %% Defaults --- If input arguments are not provided, these gives the default values
    
    if exist('itemsLeft','var') == 0;
        itemLeft{1} = imread('vjuice.jpg');
    end
    if exist('itemsRight','var') == 0;
        itemsRight{1} = imread('icedtea.jpg');
    end
    
    if exist('flip','var') == 0; % If 'itemitemsOnLeft' doesn't exist  . . . 
        flip = 0;                % Create it and set it equal to 3 (default)
    end
    
    if exist('w','var') == 0;
        w = Screen(screenNumber, 'OpenWindow',[],[],[],[]);
    end
    
    black = imread('black.jpg');
    grey = imread('grey.jpg');
    
    %% Make all of the tesxtures
    %Textures for the first group
    leftTextures = {};
    for i = 1: numel(itemsLeft)
        tempTexture = Screen('MakeTexture',w,itemsLeft{i});
        leftTextures = {leftTextures, tempTexture};
    end
    %Textures for the second group
    rightTextures = {};
    for i = 1: numel(itemsRight)
        tempTexture = Screen('MakeTexture',w,itemsRight{i});
        rightTextures = {rightTextures, tempTexture};
    end
    
    %%placeholders
    blackt = Screen('MakeTexture',w,black);
    greyt = Screen('MakeTexture',w,grey);
    
    %% These are all of the position constants  

    centerw = width/2;  % This the center width of the screen
    centerh = height/2; % THe center of the height of the screen
    eccen =   150;       % This is the eccentricity. Distance from the center to the right edge of the array
    itemw =   70;       % The width of one item in the array
    itemh =   1.5*itemw;% The hight of one item in the array
    gutterw = 20;       % The width of the gutters between the items
    gutterh = 20;       % The hight of the gutters between the items
    
    devLineHeight = height*.9;  % The height of the black box inthe middle of the screen
    devLineWidth  = 1;          % The width of the black box in the middle of the screen
    
    % EVerything below here is codded in terms of the numbers above
    
    leftPositions = [];
    rightPositions = [];
    topPositions = centerh - devLineHeight/2;
    bottomPositions = centerh + devLineHeight/2;
    
    %%Do all the math for the lines for each item
    %%starting with the ones on the left side of the screen
    currentRightSide = centerw - eccen;
    for i = 1: numel(leftTextures)
        %Set border
        rightBorder = currentRightSide;
        leftBorder = rightBorder - itemw;
        %Reset for next item
        currentRightSide = leftBorder - gutterw;
        %Add to positions array
        leftPositions = [leftPositions, leftBorder];
        rightPositions = [rightPositions, rightBorder];
    end
    
    %%Do all the math for the lines for each item
    %%right side of the screen
    currentLeftSide = centerw + eccen;
    for i = 1: numel(rightTextures)
        %Set border
        leftBorder = currentLeftSide;
        rightBorder = leftBorder + itemw;
        %Reset for next item
        currentLeftSide = rightBorder + gutterw;
        %Add to positions array
        leftPositions = [leftPositions, leftBorder];
        rightPositions = [rightPositions, rightBorder];
    end
    
    
    pwr1= centerw + eccen;
    pwr2= pwr1 + itemw;
    pwr3= pwr2 + gutterw;
    pwr4= pwr3 + itemw;
    pwr5= pwr4 + gutterw;
    pwr6= pwr5 + itemw;
    pwr7= pwr6 + gutterw;
    pwr8= pwr7 + itemw;
    
    ph1= centerh - (gutterh + 1.5*itemh);
    ph2= ph1 + itemh;
    ph3= ph2 + gutterh;
    ph4= ph3 + itemh;
    ph5= ph4 + gutterh;
    ph6= ph5 + itemh;
    
% These are here so that the cat()'s will have something to grab on to.

    draw = [];
    
% The line that devides the the screen in half    
    
     draw = cat(1,draw,blackt);
     leftPositions = cat(2,leftPositions,    centerw - devLineWidth);
     topPositions = cat(2,topPositions,      centerh - devLineHeight/2);
     rightPositions = cat(2,rightPositions,  centerw + devLineWidth);
     bottomPositions = cat(2,bottomPositions,centerh + devLineHeight/2);

    
% Left    
% Box 1l    
if amountOfItem1 >= 1;  %If there is suposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
    draw = cat(1,draw,item1t);
    leftPositions = cat(2,leftPositions,    pwl4);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwl3);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 2L    
if amountOfItem1 >= 2;
    draw = cat(1,draw,item1t);
    leftPositions = cat(2,leftPositions,    pwl2);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwl1);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 3L    
if amountOfItem1 >= 3;
    draw = cat(1,draw,item1t);
    leftPositions = cat(2,leftPositions,    pwl4);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwl3);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box 4L    
if amountOfItem1 >= 4;
    draw = cat(1,draw,item1t);
    leftPositions = cat(2,leftPositions,    pwl2);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwl1);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box 5L    
if amountOfItem1 >= 5;
    draw = cat(1,draw,item1t);
    leftPositions = cat(2,leftPositions,    pwl4);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwl3);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box 6L    
if amountOfItem1 >= 6;
    draw = cat(1,draw,item1t);
    leftPositions = cat(2,leftPositions,    pwl2);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwl1);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box 7L    
if amountOfItem2 >= 1;
    draw = cat(1,draw,item2t);
    leftPositions = cat(2,leftPositions,    pwl6);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwl5);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 8L    
if amountOfItem2 >= 2;
    draw = cat(1,draw,item2t);
    leftPositions = cat(2,leftPositions,    pwl8);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwl7);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 9L    
if amountOfItem2 >= 3;
    draw = cat(1,draw,item2t);
    leftPositions = cat(2,leftPositions,    pwl6);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwl5);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box10L    
if amountOfItem2 >= 4;
    draw = cat(1,draw,item2t);
    leftPositions = cat(2,leftPositions,    pwl8);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwl7);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box11L    
if amountOfItem2 >= 5;
    draw = cat(1,draw,item2t);
    leftPositions = cat(2,leftPositions,    pwl6);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwl5);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box12L    
if amountOfItem2 >= 6;
    draw = cat(1,draw,item2t);
    leftPositions = cat(2,leftPositions,    pwl8);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwl7);
    bottomPositions = cat(2,bottomPositions, ph6);
end

% Right
% Box 1r    
if amountOfItem3 >= 1;
    draw = cat(1,draw,item3t);
    leftPositions = cat(2,leftPositions,    pwr3);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwr4);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 2r    
if amountOfItem3 >= 2;
    draw = cat(1,draw,item3t);
    leftPositions = cat(2,leftPositions,    pwr1);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwr2);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 3r    
if amountOfItem3 >= 3;
    draw = cat(1,draw,item3t);
    leftPositions = cat(2,leftPositions,    pwr3);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwr4);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box 4r    
if amountOfItem3 >= 4;
    draw = cat(1,draw,item3t);
    leftPositions = cat(2,leftPositions,    pwr1);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwr2);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box 5r    
if amountOfItem3 >= 5;
    draw = cat(1,draw,item3t);
    leftPositions = cat(2,leftPositions,    pwr3);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwr4);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box 6r    
if amountOfItem3 >= 6;
    draw = cat(1,draw,item3t);
    leftPositions = cat(2,leftPositions,    pwr1);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwr2);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box 7r    
if amountOfItem4 >= 1;
    draw = cat(1,draw,item4t);
    leftPositions = cat(2,leftPositions,    pwr5);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwr6);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 8r    
if amountOfItem4 >= 2;
    draw = cat(1,draw,item4t);
    leftPositions = cat(2,leftPositions,    pwr7);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwr8);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 9r    
if amountOfItem4 >= 3;
    draw = cat(1,draw,item4t);
    leftPositions = cat(2,leftPositions,    pwr5);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwr6);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box10r    
if amountOfItem4 >= 4;
    draw = cat(1,draw,item4t);
    leftPositions = cat(2,leftPositions,    pwr7);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwr8);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box11r    
if amountOfItem4 >= 5;
    draw = cat(1,draw,item4t);
    leftPositions = cat(2,leftPositions,    pwr5);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwr6);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box12r    
if amountOfItem4 >= 6;
    draw = cat(1,draw,item4t);
    leftPositions = cat(2,leftPositions,    pwr7);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwr8);
    bottomPositions = cat(2,bottomPositions, ph6);
end

%Greys
% Left    
% Box 1l    
if amountOfItem1 < 1;  %If there is suposed to be one or more item(s) on the left, Add all on the numbers that we need to add so that a image will be drawn in the 1 position
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl4);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwl3);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 2L    
if amountOfItem1 < 2;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl2);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwl1);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 3L    
if amountOfItem1 < 3;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl4);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwl3);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box 4L    
if amountOfItem1 < 4;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl2);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwl1);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box 5L    
if amountOfItem1 < 5;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl4);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwl3);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box 6L    
if amountOfItem1 < 6;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl2);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwl1);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box 7L    
if amountOfItem2 < 1;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl6);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwl5);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 8L    
if amountOfItem2 < 2;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl8);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwl7);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 9L    
if amountOfItem2 < 3;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl6);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwl5);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box10L    
if amountOfItem2 < 4;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl8);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwl7);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box11L    
if amountOfItem2 < 5;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl6);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwl5);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box12L    
if amountOfItem2 < 6;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwl8);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwl7);
    bottomPositions = cat(2,bottomPositions, ph6);
end

% Right
% Box 1r    
if amountOfItem3 < 1;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr3);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwr4);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 2r    
if amountOfItem3 < 2;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr1);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwr2);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 3r    
if amountOfItem3 < 3;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr3);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwr4);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box 4r    
if amountOfItem3 < 4;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr1);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwr2);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box 5r    
if amountOfItem3 < 5;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr3);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwr4);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box 6r    
if amountOfItem3 < 6;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr1);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwr2);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box 7r    
if amountOfItem4 < 1;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr5);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwr6);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 8r    
if amountOfItem4 < 2;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr7);
    topPositions = cat(2,topPositions,       ph3); 
    rightPositions = cat(2,rightPositions,  pwr8);
    bottomPositions = cat(2,bottomPositions, ph4);
end
% Box 9r    
if amountOfItem4 < 3;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr5);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwr6);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box10r    
if amountOfItem4 < 4;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr7);
    topPositions = cat(2,topPositions,       ph1); 
    rightPositions = cat(2,rightPositions,  pwr8);
    bottomPositions = cat(2,bottomPositions, ph2);
end
% Box11r    
if amountOfItem4 < 5;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr5);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwr6);
    bottomPositions = cat(2,bottomPositions, ph6);
end
% Box12r    
if amountOfItem4 < 6;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pwr7);
    topPositions = cat(2,topPositions,       ph5); 
    rightPositions = cat(2,rightPositions,  pwr8);
    bottomPositions = cat(2,bottomPositions, ph6);
end

v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);

    Screen('DrawTextures',w,draw,[],v)
%      Screen('Flip',w);
%      KbWait
%      Screen('CloseAll');

end

