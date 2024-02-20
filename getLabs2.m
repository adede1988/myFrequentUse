function [labels, errorReport] = getLabs2(varargin) 

switch nargin
    case 1
        elec = varargin{1}; 
        notes = [];
        hasNotes = false; 
    case 2
        elec = varargin{1};
        notes = varargin{2};
        hasNotes = true; 
end


%% check if there's anything in the meeting notes
try
  
    if ~iscell(notes.LocMeeting(1))
        hasNotes = false; 
    end
    
catch

    try 
        if  ~iscell(notes.Loc_meeting(1))

            hasNotes = false; 
        else

            notes = renamevars(notes, "Loc_meeting", "LocMeeting");
        end
    catch
        if isnan(notes)
            hasNotes = false; 
        end
    end
    
end

%% check for dumbly named electrodes

try
if strcmp("A'1", notes.Electrode(1))
    for li = 1:length(notes.Electrode)
        cur = split(notes.Electrode(li), "'");
        if length(cur)==2
        notes.Electrode(li) = {[cur{1} cur{2} '_left']};
        end
    end
elseif length(split(notes.Electrode(1), " " ) )>1
    for li = 1:length(notes.Electrode)
        cur = split(notes.Electrode(li), " ");
        if length(cur)==2
        notes.Electrode(li) = {[cur{1} cur{2}]};
        end
    end

elseif strcmp(notes.Properties.VariableNames(2), 'originalLabel')
    notes.Electrode = notes.originalLabel;
    for li = 1:length(elec.label)
        curLab = elec.label{li}; 
        [ch, ~] = split(curLab, '-');
        if length(ch{1}) == 2 && length(ch{2}) == 2
            elec.label{li} = [ch{1}(1) '0' ch{1}(2) '-' ch{2}(1) '0' ch{2}(2) ];
        elseif length(ch{1}) ==2
            elec.label{li} = [ch{1}(1) '0' ch{1}(2) '-' ch{2} ];
        elseif length(ch{2}) ==2
            elec.label{li} = [ch{1} '-' ch{2}(1) '0' ch{2}(2) ];
        end

    end
    for li = 1:length(notes.Electrode)
        if length(notes.Electrode{li}) == 2
            notes.Electrode{li} = [notes.Electrode{li}(1) '0' notes.Electrode{li}(2)];
        end
    end

end
catch
disp(['possible misnamed notes'])
end

%% check for nan electrodes and eliminate

if sum(isnan(elec.elecpos(:,1)))>0
    deletei = isnan(elec.elecpos(:,1)); 
    elec.label(deletei) = [];
    elec.elecpos(deletei,:) = [];
    elec.chanpos(deletei,:) = []; 
end



%% simplified codes: 

ignore = {'other'}; 
iTemp = {'iTemp'};
acc = {'acc', 'aCC', 'ACC'}; 
hip = {'hip', 'hippocampus'}; 
lTemp = {'lTemp', 'lTEmp'};
dlPFC = {'dlPFC'}; 
pPFC = {'polar PFC', 'Polar PFC'}; 
vis = {'Vis'}; 
pcc = {'PCC'}; 
mtl = {'MTL'}; 




%% now find labels
%bug for later: spit out some record of second channel conflicts where they
%exist 

errorReport = struct; 
ei = 1; 
labels = cell(size(elec.label,1),5); %chan 1 out, chan 2 out, final out, chan 1 in, chan 2 in
for li = 1:length(elec.label)
    curLab = elec.label{li}; 
    [ch, ~] = split(curLab, '-');

    %patch for dumb electrode labels 
    if length(split(ch{1}, "'"))==2
        for chani = 1:2
            tmp = split(ch{chani}, "'"); 
            ch{chani} = [tmp{1} tmp{2}]; 
            
        end
    end
    
    if hasNotes
        
        try
            ch1i = find(cellfun(@(x) ~isempty(x), strfind(notes.Electrode, ch{1})),1);
            ch2i = find(cellfun(@(x) ~isempty(x), strfind(notes.Electrode, ch{2})),1);
        catch
            ch1i = find(cellfun(@(x) ~isempty(x), strfind(notes.Label, ch{1})),1);
            ch2i = find(cellfun(@(x) ~isempty(x), strfind(notes.Label, ch{2})),1);
        end

%         if strcmp('originalLabel', notes.Properties.VariableNames{2})
%             ch1i = find(cellfun(@(x) ~isempty(x), strfind(notes.originalLabel, ch{1})),1);
%             ch2i = find(cellfun(@(x) ~isempty(x), strfind(notes.originalLabel, ch{2})),1);
%         end



%         ch1 = notes.LocMeeting{ch1i};
%         ch2 = notes.LocMeeting{ch2i};
        if ~isempty(ch1i) && ~isempty(ch2i)
        if isempty(notes.LocMeeting{ch1i}) && isempty(notes.LocMeeting{ch2i})
            labels{li, 1} = {'NO NOTES'};
            labels{li, 2} = {'NO NOTES'};
        else


        chi = [ch1i, ch2i]; 
        for ii = 1:2
            ch = notes.LocMeeting{chi(ii)};
            labels{li,ii+3} = ch; %store the original inputs! 
        if sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), iTemp, 'uniformoutput', false))) > 0
                labels{li,ii} = 'iTemp'; 
                %superior frontal sulcus
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), acc, 'uniformoutput', false))) > 0
                labels{li,ii} = 'acc'; 
                %anterior cingulate cortex
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), hip, 'uniformoutput', false))) > 0
                labels{li,ii} = 'hip'; 
                %anterior cingulate cortex  
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), lTemp, 'uniformoutput', false))) > 0
                labels{li,ii} = 'lTemp'; 
                %anterior cingulate cortex  
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), dlPFC, 'uniformoutput', false))) > 0
                labels{li,ii} = 'dlPFC'; 
                %medial frontal gyrus 
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), pPFC, 'uniformoutput', false))) > 0
                labels{li,ii} = 'pPFC'; 
                %inferior frontal gyrus  
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), vis, 'uniformoutput', false))) > 0
                labels{li,ii} = 'vis'; 
                %middle frontal sulcus  
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), pcc, 'uniformoutput', false))) > 0
                labels{li,ii} = 'pcc'; 
                %claustrum  
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), mtl, 'uniformoutput', false))) > 0
                labels{li,ii} = 'mtl'; 
                %claustrum  
       
        elseif sum(cellfun(@(y) ~isempty(y), cellfun(@(x) strfind(ch, x), ignore, 'uniformoutput', false))) > 0
                labels{li,ii} = 'ZZZ'; 
                %white/out of brain
        else
                errorReport(ei).elec = li; 
                errorReport(ei).flag = 'unknown'; 
                errorReport(ei).inName = ch; 
                ei = ei+1;



        end
        end
        end
        else
                errorReport(ei).elec = li; 
                errorReport(ei).flag = 'unknown'; 
                errorReport(ei).inName = ch; 
                ei = ei+1;

        end

    else % couldn't use notes

        labels{li, 1} = {'NO NOTES'};
        labels{li, 2} = {'NO NOTES'};


    end



   
   




end


    
    


 %make third position label: 
 for li = 1:length(elec.label)
    ch1 = labels{li,1}; 
    ch2 = labels{li,2};
    if strcmp('ZZZ', ch1) || strcmp('NO NOTES', ch1)
        labels{li,3} = ch2; 
    else
        labels{li,3} = ch1; 
    end


end













end