  clear all; clc
  path=['C:\Users\epetru\Desktop\Behavioral Analysis\aIC-BLA Eli\NSFT\20230502_NSFT_aIC-BLA\Outputs\HFD plot'];
  outputpath=['C:\Users\epetru\Desktop\Behavioral Analysis\aIC-BLA Eli\NSFT\20230502_NSFT_aIC-BLA\Outputs\HFD plot'];
  dirOutput=dir(fullfile(path,'*.mat'));
  fileNames={dirOutput.name};
  n=length(fileNames); 
  Map=nan(120,120);
  %map=nan(54,86,n);
  %map=nan(54,86,n);
  for i=1:n
      
   tmp_file=char(fileNames(i));
   tmp_path=[path filesep tmp_file];
   load(tmp_path)
   ii = isnan(experiment.map.NormSig.IO);
   experiment.map.NormSig.IO(ii)=0;
   gaussFilt_PercAvgSigMap = imgaussfilt(experiment.map.NormSig.IO,experiment.p.PhotometrySignalMap_sigmaGaussFilt);
   gaussFilt_PercAvgSigMap(ii)=nan;
   gaussFilt_PercAvgSigMap=gaussFilt_PercAvgSigMap./max(gaussFilt_PercAvgSigMap(:));
   map(:,:,i)=gaussFilt_PercAvgSigMap;
        
  end 
    map=nanmean(map, 3);

    f=figure(1)
    hold on
    xMax=experiment.p.xMax/0.5;yMax=experiment.p.xMax/0.5;
    xlim([0 xMax])
    ylim([0 yMax])
    set(gca,'Ydir','reverse')
    colormap([1 1 1; jet(1024)]);
    im=imagesc(map);
  
    hBar=colorbar('horiz');
    box off
    caxis([-1,1])
    set(get(hBar,'title'),'string','\Delta F/F (%)','Fontname', 'Arial', 'Fontsize', 10)
    set(hBar, 'Position', [0.624 0.046 0.2 0.02], 'YTickLabel', {'-1','0','1'},'Fontname', 'Arial', 'Fontsize', 10);
    set(0,'defaultfigurecolor','w') 
    
    x1=experiment.apparatusDesign_cmSP.x/0.5;
    y1=experiment.apparatusDesign_cmSP.y/0.5;
    x1=[x1,x1(1,1)];
    y1=[y1,y1(1,1)];
    plot(x1, y1, 'k', 'linewidth',1)
    axis equal
    axis off
    hold on
    x2=[experiment.vData.zones_cmSP(2).xV]/0.5;
    y2=[experiment.vData.zones_cmSP(2).yV]/0.5;
    plot(x2, y2, '--k', 'linewidth',1)
    
    filename = fullfile(outputpath,'Heatmap_OFT_FD_hypercenter');
    print(filename,'-dpdf','-painters','-r1200');
    print(filename,'-djpeg','-painters','-r1200');
    %close(figure(1))
  %  print(f,figName,'-djpeg');
    %close(f);
