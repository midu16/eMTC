% Calculate the Cell RS REs and symbols corresponding to the 'core' PBCH
% part
function [pbchCoreCellRSSymbols,pbchCoreCellRSIndices] = getPBCHCoreCellRS(enb)

    % We need to repeat the cell reference signals within the (k,l) region
    NscRB = 12;
    k = (enb.NDLRB*NscRB)/2 -36 + (0:71) + 1; % 1-based full possible PBCH subcarrier locations
    if strcmpi(enb.CyclicPrefix,'Normal')
        NsymbDL = 7;
    else
        NsymbDL = 6;
    end
    l = NsymbDL+ (0:3)+ 1; % 1-based OFDM symbol numbers in the subframe corresponding to PBCH core part

    % NOTE: The cell RS symbols and indices can be looked up from the
    % grid if provided or can be created here as shown below
    cellRSIndices = lteCellRSIndices(enb);
    cellRSSymbols = lteCellRS(enb);
    rsgrid = lteDLResourceGrid(enb);
    rsgrid(cellRSIndices) = cellRSSymbols;
    % Now remove all RS symbols outside of the core PBCH band
    excludeSubs = setdiff(1:enb.NDLRB*NscRB,k);
    excludeofdmSymbols = setdiff(1:NsymbDL*2,l);
    % Now remove all the unwanted RE locations
    rsgrid(:,excludeofdmSymbols,:) = 0;
    rsgrid(excludeSubs,:,:) = 0;

    % What is in the grid is the RS symbols to be repeated
    pbchCoreCellRSIndices = find(rsgrid);
    pbchCoreCellRSSymbols = rsgrid(pbchCoreCellRSIndices);

end