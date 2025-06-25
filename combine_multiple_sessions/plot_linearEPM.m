clear; clc; close all;


r = 'S:\_Céline\Papers\aIC anxiety and valence\Submission R2\Analysis R2\Linear EPM R2\Output aIC';

l = dir([r filesep '*.mat']);

n = size(l,1);

data = []
nBins=0;
nRow=0;


% Ici, on choisit ce que l'on veut plotter
varName = {'experiment.armAlignedSig.I.Openarm'};
ylim_ = [-2 4]; % fixe les limites en y; auto si vide ylim_=[];


load([r filesep 'analysisParams.mat']);

for i=1:n
    f=l(i).name;
    if ~strcmp(f,'analysisParams.mat')       
        load([r filesep f]);
        cmd=sprintf('tmp = %s;',varName{:});
        eval(cmd);
        
        if i==1
            nBins = size(tmp,2);
            nRows = n-1;
            data = nan(nRows,nBins);
        end
        
        data(i,:)=tmp;
      
    end
end

mean_ = nanmean(data);
sem_ = nanstd(data)/sqrt(nRows);

x = 0:nBins-1;
x = x*p.MapScale_cmPerBin;


figure();
hold on
if ~isempty(ylim_)
    ylim(ylim_);
end

shadedErrorBar(x,mean_,sem_);

print([r filesep varName{:} '.pdf'],'-dpdf','-painters','-r1200');

close all


