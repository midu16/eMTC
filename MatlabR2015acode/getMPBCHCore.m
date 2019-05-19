% Get the MPBCH Core part symbols
function mpbchCoreSym = getMPBCHCore(enb)

    bchBits = lteMIB(enb);
    pbchBits = lteBCH(enb,bchBits);
    mpbchCoreSym = ltePBCH(enb,pbchBits);
    % Reshape to the four parts to go on to 4 frames
    mpbchCoreSym = reshape(mpbchCoreSym,numel(mpbchCoreSym)/4,4);
end
