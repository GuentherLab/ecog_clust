%%%% set machine-specific paths for accessing data remotely
%
% scripts and functions for ECoG-Clust project
%
% updated 2022/7/20 by AM

compname  = getenv('COMPUTERNAME');

switch compname
    case 'MSI' % Andrew Meier laptop, mapped drive
        ROOT_DIR = 'B:';
        % following path contains bad version of binocdf
        rmpath('C:\docs\code\matlab\packages\fieldtrip-20210616\external\stats')
    otherwise
        ROOT_DIR = ''; %%% for accessing SCC directly vs SSH
end

addpath([ROOT_DIR, filesep, '/project/busplab/software/ecog/util' ])
addpath([ROOT_DIR, filesep, '/project/busplab/software/spm12' ])
addpath([ROOT_DIR, filesep, '/project/busplab/software/conn' ])
addpath([ROOT_DIR, filesep, '/project/busplab/software/display' ])
addpath([ROOT_DIR, filesep, '/project/busplab/software/display/surf' ])

clear compname