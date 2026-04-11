

function shift_led_in_time(shift_sec, p)

    [filepath, name, ext] = fileparts(p);
    v = [filepath filesep name(1:end-7) '.mp4']
    
    v = VideoReader(v);
    shift_frame = shift_sec*v.FrameRate;

    header = readcell(p, 'Range', '1:1');

    A = readmatrix(p, 'NumHeaderLines', 1);
    
    B = A(:,7);
    
    k = abs(shift_frame)
    
    if shift_frame>0
        B_ = nan(size(B));    % same size, filled with NaN
        B_(k+1:end, :) = B(1:end-k, :);
    else
        B_ = nan(size(B));
        B_(1:end-k, :) = B(k+1:end, :);
    end
    
    % 
    % figure()
    % hold on
    % plot(B,'r')
    % plot(B_,'g')
    % 
    A(:,7) = B_;
    
    outname = [filepath filesep name(1:end-7) '-bonsaiShifted.txt']
    writecell(header, outname);            % write header
    writematrix(A, outname, 'WriteMode','append');
end



