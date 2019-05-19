% Calculate the PDSCH allocation
function prbset = getPDSCHAllocation(enb,PDSCH)
    if PDSCH.Hopping
        % Cat-M1 mode with hopping
        prbset = getHoppingAllocation(enb,PDSCH);
    else
        % Calculate the allocations in narrowband(s)
        [prbsets,nNB] = calcNarrowbandPRBSets(enb.NDLRB);
        % Calculate the PRBSet for this subframe, they are on the same RBs
        % within all narrowbands
        rbstartIndex = mod(find(prbsets == PDSCH.InitPRBSet(1))-1,6)+1;
        rbendIndex = mod(find(prbsets == PDSCH.InitPRBSet(end))-1,6)+1;
        if isempty(rbstartIndex) || isempty(rbendIndex)
           error('Invalid PRBSet specified, must be resources within narrowbands');
        end
        if any(PDSCH.InitNarrowbandIndex > max(nNB))
           error('Invalid InitNarrowbandIndex specified, must be from the set 0...%d',max(nNB));
        end
        prbset = prbsets(rbstartIndex:rbendIndex,PDSCH.InitNarrowbandIndex+1);
        prbset = prbset(:);

    end

end