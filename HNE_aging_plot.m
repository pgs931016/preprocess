clc;clear;close all
folder_path{1} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 1C (25-42)\10degC';
folder_path{2} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 4C (25-42)\10degC';
folder_path{3} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\1CPD 1C (25-42)\10degC';
% folder_path{1} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 4C (25-39)\10degC';
% folder_path{2} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 3C (25-39)\10degC';
% folder_path{3} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 3C (25-40)\10degC';
% folder_path{4} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 2C (25-40)\10degC';
% folder_path{5} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 3C (25-41)\10degC';
% folder_path{6} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 2C (25-41)\10degC';
% folder_path{7} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 1C (25-41)\10degC';
% folder_path{8} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 4C (25-42)\10degC';
% folder_path{9} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 2C (25-42)\10degC';
% folder_path{10} = 'G:\공유 드라이브\BSL_Dsata2\HNE_AgingDOE_Procesed\HNE_FCC\4CPD 1C (25-42)\10degC';
% folder_path{11} = 'G:\공유 드라이브\BSL_Data2\HNE_AgingDOE_Processed\HNE_FCC\4CPD 0.5C (25-42)\10degC';


legend_texts = {}; 
for k = 1:length(folder_path)
    % 해당 폴더의 파일 정보를 가져와서 data 변수에 저장
   merged_files = dir(fullfile(folder_path{k}, '*s01*Merged.mat'));


    for n = 1:length(merged_files)
       % 데이터 불러오기
       fullpath_now = fullfile(folder_path{k},merged_files(n).name);
       data_now = load(fullpath_now);
       % 데이터 필드 잇는지 에러 확인
       if ~isfield(data_now, 'data_merged')
           error('File "%s" does not contain the expected variable "data".', merged_files(n).name);
       end
       data_merged = data_now.data_merged;


   
    fileParts = strsplit(merged_files(n).name, '_');
    newNamePart = strjoin(fileParts(end-5:end-3)); 
    legend_texts{end+1} =  newNamePart;



figure(1)
data_D = data_merged(([data_merged.type]=='D')&(abs([data_merged.Q])>0.001)&([data_merged.rptflag]==0)|([data_merged.OCVflag])==2);
scatter([data_D.cycle],abs([data_D.Q])*1000)
ylim([0 5]);
xlabel('Cycle (n)');
ylabel('Cap (mAh)');  
legend(legend_texts);
hold on;

figure(2)
Q_D_max = data_merged(([data_merged.type]=='D')&([data_merged.OCVflag])==2);
Q_D_max = Q_D_max(1).Q;
ylim([0 1.2]);
xlabel('Cycle (n)');
ylabel('Cap / Cap0');

Q_norm  = abs([data_D.Q]) / abs(Q_D_max);
scatter([data_D.cycle],Q_norm)
legend(legend_texts);
hold on;

figure(3)
data_D_t = [];
for i = 1:length(data_D)
data_D_t = [data_D_t, data_D(i).t(end)]; 
end
scatter(data_D_t/3600,Q_norm)
ylim([0.4 1.2]);
xlabel('Time (h)');
ylabel('Cap / Cap0');
legend(legend_texts);
hold on;

% figure(4)
% plot(data_merged.t, data_merged.I);
% 
% xlabel('Time (h)');
% ylabel('Current (mAh)');
% legend(newNamePart);hold on;
% 
% 
% figure(5)
% plot(data_merged.t, data_merged.V);
% 
% xlabel('time (h)');
% ylabel('Voltage (V)');
% legend(newNamePart);hold on;

    end
end
% figure(1)
% legend(legend_texts);
% 
% figure(2)
% legend(legend_texts);
% 
% figure(3)
% legend(legend_texts);
% 
% figure(4)
% legend(legend_texts);
% 
% figure(5)
% legend(legend_texts);



  % legendFontSize = 16; % 적절한 폰트 크기로 변경하세요
  %   legend_handle = legend('레전드1', '레전드2', '레전드3'); % 레전드 핸들을 가져옵니다.
  %   set(legend_handle, 'FontSize', legendFontSize); % 레전드의 폰트 크기를 설정합니다.