% Get the absolute subframe number in a frame which is used for the last
% transmission of a channel
function sfsnumlastFrame = getlastabsSF(dlsfs,totmtcSubframes)
    sfslastFrame = mod(totmtcSubframes,sum(dlsfs)); % subframes to tx in the last frame
    if sfslastFrame
        % Find the subframe number corresponding to the last subframe to transmit
        sfsnumlastFrame = find(dlsfs,sfslastFrame);
        sfsnumlastFrame = sfsnumlastFrame(end);
    else
        % No partial frames required
        sfsnumlastFrame = 0;
    end

end