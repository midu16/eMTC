% Calculate the resource blocks allocated in the hopping narrowband
function prbset = getHoppingAllocation(enb,chs)

    % If frequency hopping is disabled, the allocation is same as initial
    if ~chs.Hopping
        prbset = chs.InitPRBSet;
        return
    end

    % Hopping narrowband calculation according to TS 36.211 section 6.8B.5
    nNBi0ss = 0;
    % Get the possible narrowbands and associated PRBSets
    if strcmpi(enb.DuplexMode,'FDD')
        idelta = 0;
    else
        idelta = enb.NChDLNB-2;
    end
    j0 = floor((chs.InitNSubframe+idelta)/enb.NChDLNB);
    % Get the narrowbands and corresponding resources
    [prbsets,nNB] = calcNarrowbandPRBSets(enb.NDLRB);
    % Calculate the narrowband for this subframe
    enb.NSubframe = enb.NFrame*10+enb.NSubframe; % Get the absolute subframe number
    nnBi = mod( (nNBi0ss + (mod(floor((enb.NSubframe+idelta)/enb.NChDLNB - j0),enb.NChDLNBhop))*enb.HoppingOffset) ,numel(nNB));
    % Calculate the PRBSet for this subframe, they are on the same RBs
    % within the narrowband
    [rbstartIndex,nbstartIndex] = find(prbsets == chs.InitPRBSet(1));
    [rbendIndex,nbendIndex] = find(prbsets == chs.InitPRBSet(end));
    if (isempty(rbstartIndex) || isempty(rbendIndex)) || (nbstartIndex ~= nbendIndex)
       error('Invalid PRBSet specified, must be resources within single narrowband');
    end
    prbset = prbsets(rbstartIndex:rbstartIndex+numel(chs.InitPRBSet)-1,nnBi+1);

end