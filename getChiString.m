function chiOut = getChiString(chan)



    if chan<10
        chiOut = ['00' num2str(chan)];
    elseif chan<100
        chiOut = ['0' num2str(chan)];
    else 
        chiOut = num2str(chan);
    end











end