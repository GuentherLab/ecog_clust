% auto-generated by conn_jobmanager
% this script can be used to run this process from Matlab locally on this machine (or in a Matlab parallel toolbox environment)

addpath '/project/busplab/software/spm12';
addpath '/project/busplab/software/conn';
cd '/project/busplab/software/ecog/classification_AM/.qlog/210517002430258';

jobs={'/project/busplab/software/ecog/classification_AM/.qlog/210517002430258/node.0001210517002430258.mat'};
% runs individual jobs
parfor n=1:numel(jobs)
  conn_jobmanager('exec',jobs{n});
end

% merges job outputs with conn project
conn load '';
conn save;