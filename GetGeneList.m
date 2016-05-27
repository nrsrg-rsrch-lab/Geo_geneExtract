function [ geneList ] = GetGeneList(  )
%GETGENELIST Converts line separated list of genes into a mat file
%   Must have text file labeled 'Genes.txt' and have file located on path

oFile = fopen('Genes.txt');

tLine = fgets(oFile);
geneList = {};
gcount = 1;


while ischar(tLine)
    
    % Check if more than one gene in list
    lenCheck = strsplit(tLine,{'_',' '});
    
    % If only one cell
    if length(lenCheck) == 1
        % Extract and deblank
        geneS = deblank(cellstr(lenCheck));
        geneList{gcount,1} = geneS; %#ok<*AGROW>
        gcount = gcount + 1;
        tLine = fgets(oFile);
    else
        for gi = 1:length(lenCheck)
            
            tGene = deblank(lenCheck{gi});
            
            if isempty(tGene)
                
                continue
                
            elseif strcmp(tGene,'*')
                
                continue
                
            elseif strcmp(tGene,'')
                keyboard
                
            else
                
                geneList{gcount,1} = tGene;
                gcount = gcount + 1;
                
                
            end
            
        end
        tLine = fgets(oFile);
    end
    
    
end

if strcmp(geneList{length(geneList)},'')
    geneList = geneList(1:length(geneList)-1);
end

fclose(oFile);





end

