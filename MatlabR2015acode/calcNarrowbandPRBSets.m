% Calculate the widebands, narrowbands and PRBSets for the LTE carrier bandwidth
function [prbsets,nNB,nWB] = calcNarrowbandPRBSets(NDLRB)
    % Narrowbands & Widebands (See 36.211 section 6.2.7)
    NDLNB = floor(NDLRB/6);
    nNB = 0:(NDLNB-1); % Narrowbands
    if NDLNB >= 4
        NDLWB = floor(NDLNB/4);
    else
        NDLWB = 1;
    end
    nWB = 0:(NDLWB-1); % Widebands

    % PRBs in a narrowband
    ii = 0:5;
    ii0 = floor(NDLRB/2) - 6*(NDLNB/2);
    prbsets = zeros(6,numel(nNB));
    for nb = 1:numel(nNB)
        if mod(NDLRB,2) && nNB(nb)>= (NDLNB/2)
            prbsets(:,nb) = 6*(nNB(nb))+ii0+ii + 1;
        else
            prbsets(:,nb) = 6*(nNB(nb))+ii0+ii;
        end
    end
end