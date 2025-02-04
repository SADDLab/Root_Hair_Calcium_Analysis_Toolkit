
%%
%% This code analyzes the peak height, width, and prominence of each inidvidual peak in a trace. 

F1 = readtable('test_XX.xlsx');


% Make graph line color consistant
newcolors = [0 0.4470 0.7410];
colororder(newcolors);
%%
 

tableNames = {'Name','pkNum','pks','locs(Sec)','w','p'};  % 'pks': peak height; 'w': peak width at half prominence; 'p': peak prominence.
tableOutputs = array2table(zeros(0,6),'VariableNames',tableNames);
% Define y and x for graph axis.
for i=2:width(F1)
    y = F1(:,i);
    y=table2array(y);
    x = F1.Time;
   
    
% Using the findpeaks function create graph with marked peaks using preset peak parameters.
   % PeakWidth here represents width at half prominence. 
   % could set MinPeakProminence, MinPeakHeight, MinPeakWidth values to filter out noise or non-specific peaks.
   findpeaks(y, x, "MinPeakWidth", 0, "Annotate","extents");
    xlabel("Time (s)");
    ylabel("∆F/F_0");
   
    hold off
    
    % Display Peak information in vectors, may delete pks for exclusion of peak
    % height data.
    [pks,locs, w, p] = findpeaks(y, x, "MinPeakWidth", 0, "Annotate","extents");
    
    
    
    for j=1:length(pks)        
        rowToAdd = {F1.Properties.VariableNames(i),j,pks(j),locs(j),w(j),p(j)}; 
        tableOutputs = [tableOutputs; rowToAdd];
    end

end
%%