
f= 'E:\NAS_SD\SuiviClient\Beyeler\DATA\20230502_NSFT\Inputs\NSFT_lateral camera'

l = dir([f filesep '*.mp4'])
s = size(l,1)
for i=1:s
    n=l(i).name
    [filepath,name,ext] = fileparts(n)
    l2 = dir([f filesep name '*'])
    s2 = size(l2,1)
    for i2=1:s2
        n2=l2(i2).name
        n3 = strrep(n2,'_NSFT','')
        movefile([f filesep n2],[f filesep n3])
    end
end










f= 'E:\NAS_SD\SuiviClient\Beyeler\DATA\20230502_NSFT\Inputs-sideview'

l = dir([f filesep '*.mp4'])
s = size(l,1)
for i=1:s
    n=l(i).name
    n2 = strrep(n,'.mp4','-sideview.mp4')
    movefile([f filesep n],[f filesep n2])
    
end









