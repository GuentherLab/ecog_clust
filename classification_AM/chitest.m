function [chisq_pval] = chitest(top_elcs_per_cluster, total_elcs_per_cluster, top_elcs_proportion)

noutcomes = length(top_elcs_per_cluster);
degfr = noutcomes-1;
expected = top_elcs_proportion * total_elcs_per_cluster; % top electrodes if they were proportionately distributed across clusters
devstat = (top_elcs_per_cluster-expected).^2 ./ expected; % calculate deviations from expected for each outcome
chistat = sum(devstat); % chi2 test statistic
chisq_pval = chi2cdf(chistat,degfr,'upper'); % get pval