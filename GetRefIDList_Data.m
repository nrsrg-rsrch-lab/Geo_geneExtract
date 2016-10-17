function [refIDlist , noFindList ] = GetRefIDList_Data(expDATA)
%GETREFIDLIST_DATA Extracts gene ID and Geo gene chip reference ID for
%specificed Geo study with respect to User's list of genes of interest
%
% Example Usage
% [refIDlist , noFindList ] = GetRefIDList_Data('GDS2118')

[ geneList  ] = GetGeneList(  );

gene2 = {};

for ggi = 1:length(geneList)
    tgene = geneList{ggi};
    if iscell(tgene)
        t2gene = tgene{:};
        gene2{ggi,1} = t2gene; %#ok<*AGROW>
    else
        gene2{ggi,1} = tgene;
    end
end

geneUnique = unique(gene2);

gseData = load(expDATA);


gseGene = gseData.GEOSOFTData.Identifier;
gseIDref = gseData.GEOSOFTData.IDRef;


% Clean up data
gseDATA = gseData.GEOSOFTData.Data(:,3:68);

gseRowNames = gseData.GEOSOFTData.ColumnNames(1:66);

noFind = 0;
noFindList = {};
expData = nan(size(gseDATA,2),2000);
refIDnum = 1;
refIDlist = cell(2000,2);

for gi = 1:length(geneUnique)
    geneFind = geneUnique{gi};
    gseIND = ismember(gseGene,geneFind);
    gseDind = find(gseIND);
    
    if sum(gseIND) == 0;
        noFind = noFind + 1;
        noFindList{noFind} = geneFind;
    elseif sum(gseIND) > 1;
        
        gseIDs = gseIDref(gseIND);
        
        for gsI = 1:sum(gseIND)
            
            refIDlist{refIDnum,1} = geneFind;
            
            if iscell(gseIDs{gsI})
                tgse = gseIDs{gsI}{:};
                refIDlist{refIDnum,2} = tgse;
                
                expData(:,refIDnum) = transpose(gseDATA(gseDind(gsI),:));
                
                refIDnum = refIDnum + 1;
            else
                refIDlist{refIDnum,2} = gseIDs{gsI};
                
                expData(:,refIDnum) = cell2mat(transpose(gseDATA(gseDind(gsI),:)));
                
                refIDnum = refIDnum + 1;
            end
            

            
            
        end
    elseif sum(gseIND) == 1;
        
        gseID = gseIDref(gseIND);
        
        if iscell(gseID)
            tgse = gseID{:};
            refIDlist{refIDnum,1} = geneFind;
            refIDlist{refIDnum,2} = tgse;
            
            expData(:,refIDnum) = cell2mat(transpose(gseDATA(gseDind,:)));
            
            refIDnum = refIDnum + 1;
            
        else
            
            refIDlist{refIDnum,1} = geneFind;
            refIDlist{refIDnum,2} = gseID;
            
            expData(:,refIDnum) = cell2mat(transpose(gseDATA(gseDind,:)));
            
            refIDnum = refIDnum + 1;
        end
        
    end
end

% Clean up reflist
empID = cellfun(@(x) ~isempty(x), refIDlist(:,1));
refIDlist = refIDlist(empID,:);
% Clean up data
nanID = ~isnan(expData(1,:));
expData = expData(:,nanID);

% Fix Judy gene names
for gi = 1:length(refIDlist);
    
    tg = refIDlist{gi,1};
    tmpS = strsplit(tg,'-');
    if length(tmpS) ~= 1
        refIDlist{gi,1} = [tmpS{:}];
    else
        continue
    end
end



for vi = 1:length(refIDlist)
    vT = refIDlist{vi,2};
    refIDlist{vi,3} = ['Ref_',vT];
    
end
    

% tAb = array2table(expData, 'VariableNames', transpose(refIDlist(:,3)));

outCellarray = [['RefID';'Gene';gseRowNames] , [ transpose(refIDlist(:,2)) ; transpose(refIDlist(:,1)) ; num2cell(expData)]];

filename = [expDATA , '_Exp.xlsx'];

xlswrite(filename,outCellarray)


end
















