clear all; clc
path=['C:\Users\lpages\Desktop\plot\SD_aIC'];
outputpath=['C:\Users\lpages\Desktop\plot\SD_aIC'];
dirOutput=dir(fullfile(path,'*.mat'));
fileNames={dirOutput.name};
n=length(fileNames);
sfreq=29; 
SignalaroundLicking=nan(n,401);
timebin_msec=(-10000:50:10000);
timebin_sec=timebin_msec./1000;
animal_Tag=strings([1,n]);

% Définir la couleur avant d'utiliser la variable 'color'
color = [143 40 140] / 255;  % Définition de la couleur


for i=1:n
    
    tmp_file=char(fileNames(i))
    animal_Tag(1,i)=tmp_file(1:end-4);
    tmp_path=[path filesep tmp_file];
    load(tmp_path)
    
    if isfield(experiment.pData,'avgBulkSignalAroundFood')
        SignalaroundLicking(i,:) = experiment.pData.avgBulkSignalAroundFood;
    else

        % if isfield(experiment.pData.bulkPETH,'nanmean')
        %     SignalaroundLicking(i,:)=experiment.pData.bulkPETH.nanmean;
        % end

        if isfield(experiment.vData.freezingPETH,'nanmean')
            SignalaroundLicking(i,:)=experiment.vData.freezingPETH.nanmean;
        end




    end

 % % Prendre seulement le premier événement qui ne contient pas de NaN
 %    if isfield(experiment.pData, 'avgBulkSignalAroundFood')
 %        SignalaroundLicking(i,:) = experiment.pData.avgBulkSignalAroundFood;
 %    elseif isfield(experiment.pData.bulkPETH, 'matrix') && size(experiment.pData.bulkPETH.matrix, 1) >= 1
 %        SignalaroundLicking(i,:) = experiment.pData.bulkPETH.matrix(1,:);
 %    end
 % 
 %    % Vérifier si le signal ne contient pas de NaN avant de le tracer
 %    if all(~isnan(SignalaroundLicking(i,:)))  % Vérifie qu'il n'y a pas de NaN dans le signal
 %        % Tracer le signal seulement si ce n'est pas NaN
 %        plot(timebin_sec, SignalaroundLicking(i,:), 'Color', color, 'LineWidth', 1.5);
 %        hold on;
 %    end
 % 
    % Découper les différentes phases
    signal_tmp(1,:) = SignalaroundLicking(i,:);
    Before_bite(i,:) = signal_tmp(1:2*sfreq);
    Bite(i,:) = signal_tmp(4*sfreq+1:6*sfreq);
    After_bite(i,:) = signal_tmp(6*sfreq+1:8*sfreq);
end


for i=1:n
    
    signal_tmp=SignalaroundLicking(i,:);
    timebin_sec=timebin_msec./1000;
    signal=nanmean(SignalaroundLicking);

end 


% Calcul de la moyenne et de l'erreur standard (SEM)
signal_mean = nanmean(SignalaroundLicking);
signal_sem = nanstd(SignalaroundLicking) / sqrt(sum(all(~isnan(SignalaroundLicking),2)));

% Tracer la moyenne avec SEM
figure;
shadedErrorBar(timebin_sec, signal_mean, signal_sem, 'lineprops', {'Color', color, 'LineWidth', 1.5});
ylabel('\Delta F/F (%)', 'Interpreter', 'tex');
xlabel('Time (s)');
xticks([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 ]);
ylim([-1 4]);
title('Signal moyen autour du premier événement');

% Sauvegarde
filename = fullfile(outputpath, 'Bite_MeanSignal_SEM');
print(filename, '-dpdf', '-painters', '-r1200');
close(gcf);
% 
% 
% 
% 











% sem = nanstd(SignalaroundLicking) / sqrt(size(SignalaroundLicking,1));
% plot(timebin_sec, SignalaroundLicking(1,:), 'Color', [143 40 140]./255, 'LineWidth', 1.5); % ploter le sig sur le premier event
% % Affichage avec l'erreur standard
% shadedErrorBar(timebin_sec, signal, sem, 'lineprops', {'Color', color, 'linewidth', 1.5}, 'transparent', 1);
% ylabel('\Delta F/F (%)', 'Interpreter', 'tex');
% xlabel('Time (s)')
% xticks([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10])
% % xticks([-5 -4 -3 -2 -1 0 1 2 3 4 5])
% ylim([-1 2])
% 
% filename = fullfile(outputpath,'Bite');
% print(filename,'-dpdf','-painters','-r1200');
% close(figure(1))



    
%     if isfield(experiment.pData,'avgBulkSignalAroundFood')
%         SignalaroundLicking(i,:) = experiment.pData.avgBulkSignalAroundFood;
%     else
%         if isfield(experiment.pData.bulkPETH,'nanmean')
%             SignalaroundLicking(i,:)=experiment.pData.bulkPETH.nanmean;
%         end
%     end
% 
% 
%     signal_tmp(1,:)=SignalaroundLicking(i,:);
%     Before_bite(i,:)=signal_tmp(1:2*sfreq);
%     Bite(i,:)=signal_tmp(4*sfreq+1:6*sfreq);
%     After_bite(i,:)=signal_tmp(6*sfreq+1:8*sfreq);
% 
% end
% 
% for i=1:n
% 
%     signal_tmp=SignalaroundLicking(i,:);
%     timebin_sec=timebin_msec./1000;
%     signal=nanmean(SignalaroundLicking);
% 
% end 
% 
% sem = nanstd(SignalaroundLicking) / sqrt(size(SignalaroundLicking,1));
% color=[143 40 140]./255;
% plot(timebin_sec, SignalaroundLicking(1,:), 'Color', [143 40 140]./255, 'LineWidth', 1.5); % ploter le sig sur le premier event
% shadedErrorBar(timebin_sec, SignalaroundLicking, {signal,sem}, 'lineprops', {'Color',color,'linewidth',1.5},'transparent',1)
% ylabel('\Delta F/F (%)', 'Interpreter', 'tex');
% xlabel('Time (s)')
% xticks([-10 -9 -8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9 10])
% % xticks([-5 -4 -3 -2 -1 0 1 2 3 4 5])
% ylim([-1 2])
% 
% filename = fullfile(outputpath,'Bite');
% print(filename,'-dpdf','-painters','-r1200');
% close(figure(1))
% 
% 
% 
% 
