% Aggregate data from individual data file into one big file
% This approach will allow us to do analysis while still collecting
% participants, as well as quickly exclude participants we deem to be
% outliers

% IMPORTANT: Make sure you are running file in TrackandRemember folder in
% order to properly load scripts

clc
clear

rawDataPath = [pwd '/RawData'];
dataPath = [pwd '/Data'];


files = dir(fullfile(rawDataPath, 'trackremember_ppt_1*.mat')); %Create struct of all participant data 
fileIndex = find(~[files.isdir]); % Delete subfolders
nsubj = length(fileIndex); % count files


%% Load each subject

subjects = zeros(1,nsubj);

for i = 1:length(fileIndex)
        
    % Load file name for participant
    fileName = files(fileIndex(i)).name;
    load([rawDataPath '/' fileName]);
    
    % Add subject to subjects array
    subjects(i) = data.subinfo.ppt;
    
    % Add accuracy to accuracy array 
    % Accuracy array is 3D array: (Subject,Blocktype,Trial)
    accs(i,1,:) = data.still.acc;
    accs(i,2,:) = data.move.acc;
    
    % Add response to responses array 
    % Response array is 3D array: (Subject,Blocktype,Trial)
    resps(i,1,:) = data.still.resp;
    resps(i,2,:) = data.move.resp;
    
    % Add expected response to expected response array 
    % Expected rsponse array is 3D array: (Subject,Blocktype,Trial)
    expr(i,1,:) = data.still.expr;
    expr(i,2,:) = data.move.expr;
    
    subinfo(i) = data.subinfo;
    
end

save(fullfile(dataPath, 'allData'), 'accs', 'resps', 'expr', 'subjects','subinfo');


