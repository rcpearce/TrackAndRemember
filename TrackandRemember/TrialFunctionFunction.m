function [data] = TrialFunctionFunction(nTrial,TrialType)
%% Response Screen

% Just for now
Screen('Preference', 'SkipSyncTests', 1);
screen_num = 0;
[w, rect] = Screen('OpenWindow', screen_num, [0 0 0]);
%Gotta find the center
[xCenter, yCenter] = RectCenter(rect);
%Let's also find the screen size
[screenXpixels, screenYpixels] = Screen('WindowSize', w);
vbl = Screen('Flip', w);

%% Colors
%This are the 8 colors
Color1 = [225 0 57];
Color2 = [221 0 123];
Color3 = [217 0 186];
Color4 = [160 32 240];
Color5 = [180 0 213];
Color6 = [114 0 210];
Color7 = [70 0 206];
Color8 = [50 0 220];

%I'll make the color array and assign the approporiate colors. To help
%visualize it, I recommend evaluating this part and looking at the
%array.

ColorArray = zeros(8,4);
ColorArray(:,1) = [1:8]';

ColorArray(1,2:end) = Color1;
ColorArray(2,2:end) = Color2;
ColorArray(3,2:end) = Color3;
ColorArray(4,2:end) = Color4;
ColorArray(5,2:end) = Color5;
ColorArray(6,2:end) = Color6;
ColorArray(7,2:end) = Color7;
ColorArray(8,2:end) = Color8;

%% Set up dot variables + Fixation cross

%Draw a fixation point on the center
xCoords = [-40 40 0 0];
yCoords = [0 0 -40 40];
allCoords = [xCoords; yCoords];

%Dot size/location info
r = 100;
x1 = screenXpixels/4;%dot.LocationL initial
y1 = screenYpixels/2;

x2 = screenXpixels*3/4; %dot.LocationR initial
y2 = screenYpixels/2;
black = [0 0 0];
white = [255 255 255];
grey = [160 160 160];

%Duration
dur = 2;
%% Set up trial arrays
%Here I'm creating trial indexes. Again, I recommend evaluating just this
%section to help visualizing what I'm trying to do.
TrialArray1 = [1:8]; %Because there are 8 colors total

if nTrial<=length(TrialArray1)
    TrialArray1 = TrialArray1(1:nTrial);
elseif nTrial>length(TrialArray1)
    TrialArray1 = repmat(TrialArray1, [1, nTrial]);
    TrialArray1 = TrialArray1(1:nTrial);
end
%This if statement will make sure there are nTrial number of elements in
%the TrialArray

TrialArray2 = [1:8];

if nTrial<=length(TrialArray2)
    TrialArray2 = TrialArray2(1:nTrial);
elseif nTrial>length(TrialArray2)
    TrialArray2 = repmat(TrialArray2, [1, nTrial]);
    TrialArray2 = TrialArray2(1:nTrial);
end
%There must be 2 Trial Arrays since we have 2 dots.
TrialArray1 = Shuffle(TrialArray1);
TrialArray2 = Shuffle(TrialArray2);
TrialArray = [TrialArray1;TrialArray2];

%Set it
TrialMotion = TrialArray;
TrialStat = TrialArray;

%% Target Array (Left of Right)
%This is another array deciding whether the target will be left or right.
TargetArray = [1 2];
TargetArray = repmat(TargetArray, [1 nTrial]);
TargetArray = TargetArray(1:nTrial);
TargetArray = Shuffle(TargetArray);
%% Find the locations/size for the options
%Here I'll set the locations of options for the response screen. I tried to
%soft code this but if it doesn't work on your screen I recommend tweaking
%it around.
InitialX = screenXpixels/4;
Gap = 0;
squareSize = screenXpixels/16;

for i = 1:8
    ColorLocation(i,:) = [(screenXpixels*i/18)+(squareSize*(i-1)) , yCenter-squareSize/2, (screenXpixels*i/18 )+( squareSize*i), yCenter+squareSize/2 ];
    LetterLoc(i,:) = [(screenXpixels*i/18)+(squareSize*(i-1)) , yCenter+squareSize/2];
end
%% Trial+Reponse Screen









%PRACTICE_____________________________________________________________________________________________________________________________________________
if TrialType == 0
    keypress = 0;
    
    whichKeys = [KbName('a') KbName('s') KbName('d') KbName('f') KbName('j') KbName('k') KbName('l') KbName(';')];
    nTrial = 3;
    for j = 1:nTrial
        Screen('DrawText', w, ['Press any key to start'], xCenter-150, yCenter, white);
        Screen('Flip', w);
        KbStrokeWait; %Wait until a key press

        %Color information for each dot
        colorInfo1 = ColorArray(TrialStat(1,j), 2:end);
        colorInfo2 = ColorArray(TrialStat(2,j), 2:end);
        
        HideCursor();
        
        Screen('DrawLines', w, allCoords, 4, white, [xCenter yCenter]); %Fixation Cross
        Screen('Flip', w);
        WaitSecs(1);
        
        %Draw two dots
        Screen('DrawDots', w,[x1, y1], r, colorInfo1, [0 0], 1); %This is random color dot
        Screen('DrawDots', w, [x2, y2], r, colorInfo2, [0 0], 1); %Another random color dot
        Screen('DrawLines', w, allCoords, 4, white, [xCenter yCenter]); %Fixation Cross
        Screen('Flip', w);
        WaitSecs(dur);
        
        Screen('DrawLines', w, allCoords, 4, white, [xCenter yCenter]); %Fixation Cross
        Screen('Flip', w);
        WaitSecs(1);
        
        [keyIsDown,secs,keyCode]=KbCheck();
        
        %Reponse Screen
        while(~any(keyCode(whichKeys)))
            Screen('FillRect', w, Color1, ColorLocation(1,:));
            Screen('FillRect', w, Color2, ColorLocation(2,:));
            Screen('FillRect', w, Color3, ColorLocation(3,:));
            Screen('FillRect', w, Color4, ColorLocation(4,:));
            Screen('FillRect', w, Color5, ColorLocation(5,:));
            Screen('FillRect', w, Color6, ColorLocation(6,:));
            Screen('FillRect', w, Color7, ColorLocation(7,:));
            Screen('FillRect', w, Color8, ColorLocation(8,:));
            
            if TargetArray(j) == 1
                Screen('DrawText', w, '<---', xCenter-100, yCenter-300);
                data.still.expr(j) = ColorArray(TrialStat(1,j), 1);
            elseif TargetArray(j) == 2
                Screen('DrawText', w, '--->', xCenter-100, yCenter-300);
                data.still.expr(j) = ColorArray(TrialStat(2,j), 1);
            end
            Screen('Flip', w);
            [keyIsDown,secs,keyCode]=KbCheck();
        end
        
        
        if (keyCode(KbName('a')))
            data.still.resp(j) = 1;
        elseif (keyCode(KbName('s')))
            data.still.resp(j) = 2;
        elseif (keyCode(KbName('d')))
            data.still.resp(j) = 3;
        elseif (keyCode(KbName('f')))
            data.still.resp(j) = 4;
        elseif (keyCode(KbName('j')))
            data.still.resp(j) = 5;
        elseif (keyCode(KbName('k')))
            data.still.resp(j) = 6;
        elseif (keyCode(KbName('l')))
            data.still.resp(j) = 7;
        elseif (keyCode(KbName(';')))
            data.still.resp(j) = 8;
        end
        
        
    end
    
    %STILL TRIAL_____________________________________________________________________________________________________________
elseif TrialType == 1
    keypress = 0;
    
    whichKeys = [KbName('a') KbName('s') KbName('d') KbName('f') KbName('j') KbName('k') KbName('l') KbName(';')];
    
    
    for j = 1:nTrial
        Screen('DrawText', w, ['Press any key to start'], xCenter-150, yCenter, white);
        Screen('Flip', w);
        KbStrokeWait; %Wait until a key press
        
        
        %Color information for each dot
        colorInfo1 = ColorArray(TrialStat(1,j), 2:end);
        colorInfo2 = ColorArray(TrialStat(2,j), 2:end);
        
        HideCursor();
        
        Screen('DrawLines', w, allCoords, 4, white, [xCenter yCenter]); %Fixation Cross
        Screen('Flip', w);
        WaitSecs(1);
        
        %Draw two dots
        Screen('DrawDots', w, [x1, y1], r, colorInfo1, [0 0], 1); %This is random color dot
        Screen('DrawDots', w, [x2, y2], r, colorInfo2, [0 0], 1); %Another random color dot
        Screen('DrawLines', w, allCoords, 4, white, [xCenter yCenter]); %Fixation Cross
        Screen('Flip', w);
        WaitSecs(dur);
        
        [keyIsDown,secs,keyCode]=KbCheck();
        
        Screen('DrawLines', w, allCoords, 4, white, [xCenter yCenter]); %Fixation Cross
        Screen('Flip', w);
        WaitSecs(1);
        
        %Reponse Screen
        while(~any(keyCode(whichKeys)))
            Screen('FillRect', w, Color1, ColorLocation(1,:));
            Screen('FillRect', w, Color2, ColorLocation(2,:));
            Screen('FillRect', w, Color3, ColorLocation(3,:));
            Screen('FillRect', w, Color4, ColorLocation(4,:));
            Screen('FillRect', w, Color5, ColorLocation(5,:));
            Screen('FillRect', w, Color6, ColorLocation(6,:));
            Screen('FillRect', w, Color7, ColorLocation(7,:));
            Screen('FillRect', w, Color8, ColorLocation(8,:));
            
            if TargetArray(j) == 1
                Screen('DrawText', w, '<---', xCenter-100, yCenter-300);
                data.still.expr(j) = ColorArray(TrialStat(1,j), 1);
            elseif TargetArray(j) == 2
                Screen('DrawText', w, '--->', xCenter-100, yCenter-300);
                data.still.expr(j) = ColorArray(TrialStat(2,j), 1);
            end
            Screen('Flip', w);
            [keyIsDown,secs,keyCode]=KbCheck();
        end
        
        
        if (keyCode(KbName('a')))
            data.still.resp(j) = 1;
        elseif (keyCode(KbName('s')))
            data.still.resp(j) = 2;
        elseif (keyCode(KbName('d')))
            data.still.resp(j) = 3;
        elseif (keyCode(KbName('f')))
            data.still.resp(j) = 4;
        elseif (keyCode(KbName('j')))
            data.still.resp(j) = 5;
        elseif (keyCode(KbName('k')))
            data.still.resp(j) = 6;
        elseif (keyCode(KbName('l')))
            data.still.resp(j) = 7;
        elseif (keyCode(KbName(';')))
            data.still.resp(j) = 8;
        end
        
        
    end
    
    data.still.acc = data.still.resp == data.still.expr;

%MOVING TRIAL__________________________________________________________________________
elseif TrialType == 2
    
    keypress = 0;
    
    whichKeys = [KbName('a') KbName('s') KbName('d') KbName('f') KbName('j') KbName('k') KbName('l') KbName(';')];
    
    flipSpd = 2; %  a flip every 12 frames; higher number of frames --> slower
    dispTime=2;
    monitorFlipInterval = Screen('GetFlipInterval', w);
    % retrieving screen flip interval of screen being used
    % 1/monitorFlipInterval is the frame rate of the monitor
    v=5; % velocity of ball
    side = mod(randi(10),2);
    
    %Here I'll set the locations of options for the response screen. I tried to
    %soft code this but if it doesn't work on your screen I recommend tweaking
    %it around.
    InitialX = screenXpixels/4;
    Gap = 0;
    squareSize = screenXpixels/16  ;
    [xCenter, yCenter] = RectCenter(rect);
    
    for i = 1:8
        ColorLocation(i,:) = [(screenXpixels*i/18)+(squareSize*(i-1)) , yCenter-squareSize/2, (screenXpixels*i/18 )+( squareSize*i), yCenter+squareSize/2 ];
        LetterLoc(i,:) = [(screenXpixels*i/18)+(squareSize*(i-1)) , yCenter+squareSize/2];
    end
    
    keypress=0;
    
    for j= 1:nTrial
        
        Screen('DrawText', w, ['Press any key to start'], xCenter-150, yCenter, white);
        Screen('Flip', w);
        KbStrokeWait; %Wait until a key press
        
        %Color information for each dot
        colorInfo1 = ColorArray(TrialMotion(1,j), 2:end);
        colorInfo2 = ColorArray(TrialMotion(2,j), 2:end);
        
        HideCursor();
        
        Screen('DrawLines', w, allCoords, 4, white, [xCenter yCenter]); %Fixation Cross
        Screen('Flip', w);
        WaitSecs(1);
        
        for i=1:round(dispTime/(flipSpd*monitorFlipInterval)) %to make it until you press a button
            
            Screen('DrawLine',w, grey, screenXpixels/2, screenYpixels/2-25, screenXpixels/2 ,screenYpixels/2+25, 4);
            % vertical line for fixation cross
            Screen('DrawLine',w, grey, screenXpixels/2-25, screenYpixels/2, screenXpixels/2+25 ,screenYpixels/2, 4);
            % horizontal line for fixation cross
            Screen('DrawDots', w , [x1,y1], r, colorInfo1, [0 0], 1);
            %Start ball 1 at the center of left field
            Screen('DrawDots', w, [x2, y2], r, colorInfo2, [0 0], 1);
            %start ball 2 at the center of right field
            %Screen('Flip', w);
            vbl = Screen('Flip', w, vbl+(flipSpd*monitorFlipInterval));
            
            if i==1 % if first iteration of loop
                
                dx1=(2*rand-1); dy1= (2*rand-1);
                dx2=(2*rand-1); dy2=(2*rand-1);
                %generates random initial trajectory of balls
            end
            
            
            %  dx2=(2*rand-1); dy2=(2*rand-1); %%
            %uncomment above line to view different in movement of balls
            
            
            x1 = x1+v*dx1; y1 = y1+v*dy1;
            %calculate new position of ball 1
            x2 = x2+v*dx2; y2 = y2+v*dy2;
            %calculate new position of ball 2
            
            
            theta1=atand(dy1/dx1);  theta2=atand(dy2/dx2);
            %finds trajectory angle of change in position that just occured.
            %returns value between 90deg - -90deg.
            % atand() function does not specify which cartesian quadrant of trjectory.
            % if theta value >0, dx&dy are both >0 or <0. (Quadrant 1 or 3)
            % if theta value <0, either dx or dy are <0. (Quadrant 2 or 4)
            
            
            if dx1 >=0 && dy1<0 %if trajectory vector in quadrant 4 of cartesian coords
                
                theta1= 360+theta1;
                %if in quadrant 4, theta1 will be returned as a negative value.
                %subtracting theta 1 from 360 returns the positive equivalent value.
                
            elseif dx1<0 %if trajectory vector in quadrant 2 or 3 of cartesian coords
                
                theta1= 180+theta1;
                %if theta1 is in quadrant 2 theta1 will be negative.
                %if theta1 is in quadrant 3 theta will be positive.
                % adding theta1 to 180degrees returns corresponding angle measured
                % from the origin.
                
            end
            %if none of above if statements are fulfilled, theta1 is in quadrant 1.
            
            
            if dx2 >=0 && dy2<0 %if trajectory vector in quadrant 4 of cartesian coords
                
                theta2= 360+theta2;
                %if in quadrant 4, theta2 will be returned as a negative value.
                %subtracting theta2 from 360 returns the positive equivalent value.
                
            elseif dx2<0 %if trajectory vector in quadrant 2 or 3 of cartesian coords
                
                theta2= 180+theta2;
                %if theta1 is in quadrant 2 theta1 will be negative.
                %if theta1 is in quadrant 3 theta will be positive.
                % adding theta1 to 180degrees returns corresponding angle measured
                % from the origin.
                
            end
            
            theta1= (theta1+(45))-(90*rand); theta2= (theta2+(45))-(90*rand);
            %creates trajectory angle for next 'movement' based on previous trajectory
            %new trajectory will be within 45degrees clockwise or counter-clockwise
            %of previous trajectory
            
            dx1=cosd(theta1);  dx2=cosd(theta2);
            %calculates x-component of trajectory unit vector
            
            dy1=sind(theta1);   dy2=sind(theta2);
            %calculates y-component of trajectory unit vector
            
            
            %------------------------------------------------------------------
            % x2 = max(x2, screenXpixels/2+100);
            % x2 = min(x2, screenXpixels-r*2);
            % y2 = max(y2, r*2);
            % y2 = min(y2, screenYpixels-r);
            
            %uncomment this section and comment out the next designated section to view
            %difference movement as it reaches the boundaries
            %------------------------------------------------------------------
            
            if ((x1+v*dx1) > (screenXpixels/2-100)) | ((x1+v*dx1)< r)
                %if next movement will go beyond defined 'x' boundaries
                dx1=dx1*(-1); % reverse direction of dx1 for a bounce effect
            end
            
            if ((y1+v*dy1) > (screenYpixels-r)) | ((y1+v*dy1) < r)
                % if next move will go beyond defined 'y' boundaries
                dy1=dy1*(-1); %reverse direction of dy1 for bounce effece
            end
            
            %------------------------------------------------------
            %comment section below and uncomment designated section above to view
            %difference of ball action as it reaches boundaries
            
            if ((x2+v*dx2) < (screenXpixels/2+100)) | ((x2+v*dx2) > (screenXpixels-r))
                %     %if next movement will go beyond defined 'x' boundaries
                dx2=dx2*(-1); % reverse direction of dx1 for a bounce effect
            end
            
            if ((y2+v*dy2) > (screenYpixels-r)) | ((y2+v*dy2) < r)
                %     %if next move will go beyond defined 'y' boundaries
                dy2=dy2*(-1); %reverse direction of dy1 for bounce effece
            end
            %-------------------------------------------------------------------
            
        end
        
        Screen('FillRect',w,black); %creating black screen
        Screen('DrawLine',w, grey, screenXpixels/2, screenYpixels/2-25, screenXpixels/2 ,screenYpixels/2+25, 4);
        % vertical line for fixation cross
        Screen('DrawLine',w, grey, screenXpixels/2-25, screenYpixels/2, screenXpixels/2+25 ,screenYpixels/2, 4);
        % horizontal line for fixation cross
        Screen('Flip', w);
        WaitSecs(dur);
        
        
        [keyIsDown,secs,keyCode]=KbCheck();
        
        %Reponse Screen
        while(~any(keyCode(whichKeys)))
            Screen('FillRect', w, Color1, ColorLocation(1,:));
            Screen('FillRect', w, Color2, ColorLocation(2,:));
            Screen('FillRect', w, Color3, ColorLocation(3,:));
            Screen('FillRect', w, Color4, ColorLocation(4,:));
            Screen('FillRect', w, Color5, ColorLocation(5,:));
            Screen('FillRect', w, Color6, ColorLocation(6,:));
            Screen('FillRect', w, Color7, ColorLocation(7,:));
            Screen('FillRect', w, Color8, ColorLocation(8,:));
            
            if TargetArray(j) == 1
                Screen('DrawText', w, '<---', xCenter-100, yCenter-300);
                data.move.expr(j) = ColorArray(TrialStat(1,j), 1);
            elseif TargetArray(j) == 2
                Screen('DrawText', w, '--->', xCenter-100, yCenter-300);
                data.move.expr(j) = ColorArray(TrialStat(2,j), 1);
            end
            Screen('Flip', w);
            [keyIsDown,secs,keyCode]=KbCheck();
        end
        
        
        
        if (keyCode(KbName('a')))
            data.move.resp(j) = 1;
        elseif (keyCode(KbName('s')))
            data.move.resp(j) = 2;
        elseif (keyCode(KbName('d')))
            data.move.resp(j) = 3;
        elseif (keyCode(KbName('f')))
            data.move.resp(j) = 4;
        elseif (keyCode(KbName('j')))
            data.move.resp(j) = 5;
        elseif (keyCode(KbName('k')))
            data.move.resp(j) = 6;
        elseif (keyCode(KbName('l')))
            data.move.resp(j) = 7;
        elseif (keyCode(KbName(';')))
            data.move.resp(j) = 8;
        end
        
        
    end
    
    data.move.acc = data.move.resp == data.move.expr;
end
sca
end

