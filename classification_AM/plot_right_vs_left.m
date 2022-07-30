 %%% create plots comparing top coding electrodes in right vs left hemispheres
 % 
 %%% updated 2022/7/29 by AM
 
set(0,'DefaultFigureWindowStyle','normal')
%     set(0,'DefaultFigureWindowStyle','docked')

set_paths()

% data processed by the script load_top_encoders.m
topelc_data_filename = [ROOT_DIR, filesep, 'projectnb/busplab/Experiments/ECoG_Preprocessed_AM/topelc_data_to_surf'];

% load data to plot
load(topelc_data_filename)
nclusts = length(global_clust_num_list);
n_elcs = height(elc);

%% cluster lateralization plot
close all

plotops.only_top_electrodes = 1; % if true, only plot top encoders; otherwise plot all elcs from Scott's electrode table
plotops.save_fig = 0; 
    plotops.output_resolution = 300;

plotops.ylimits = [0, 1];
plotops.xlimits = [0, 7];
plotops.leg_location = 'east';
plotops.yline_width = 2;
    plotops.yline_style = '--';
    plotops.yline_color =  [0.15 0.15 0.15];
plotops.annot_pos_xy =  [0.70, 0.78]; % position of pval annotation
plotops.bar_border_width =  2;
plotops.bar_colors =  [0.6 0.6 0.6]; 
plotops.axes_line_width =  2;
plotops.axis_font_size =  13;

plotops.axes_numbers_bold =  'bold';
plotops.font =  'Arial';
plotops.fig_width_length =  [900 600];
plotops.xticklength = [0 0];
plotops.x_tick_angle =  0; % in degrees; 0=straight; positive rotates counter-clockwise
plotops.background_color =  [1 1 1]; 
plotops.ylabel_position = [-0.7 0.5 0.5];

if plotops.only_top_electrodes
    plotops.save_fig_filename = [fileparts(topelc_data_filename) filesep 'cluster_lateralization_bars_(top_elc)'];
    plotops.ylabel = {'Fraction of top electrodes','in left hemisphere'};
    n_per_clust = topelc.anytop_n; 
    left_n_per_clust = topelc.anytop_left_n; 
    % for topelc only, yline =  L proportion of topelc only
    proportion_left_overall = sum(topelc.anytop_left_n) / sum(topelc.anytop_n);
elseif ~plotops.only_top_electrodes
    plotops.save_fig_filename = [fileparts(topelc_data_filename) filesep 'cluster_lateralization_bars_(all_elc)'];
    plotops.ylabel = {'Fraction of responsive electrodes','in left hemisphere'};
    n_per_clust = topelc.n_elc; 
    left_n_per_clust = topelc.n_elc_RL(:,2); 
    % yline is L proportion of all electrodes
    onset_aligned_is_left = isnan(elc.right_hemi(elc.type==1));
    total_onset_proportion_left = mean(onset_aligned_is_left); % proprtion of onset aligned elcs in L hem
    proportion_left_overall = total_onset_proportion_left; 
end
left_prop_by_clust = left_n_per_clust ./ n_per_clust; 

hfig = figure;
hbar = bar([left_prop_by_clust], 'stacked');

hfig.Color = plotops.background_color;
set(hfig,'Renderer', 'painters', 'Position', [50, 50, plotops.fig_width_length(1), plotops.fig_width_length(2)])
hbar(1).LineWidth = plotops.bar_border_width;
hbar(1).FaceColor = plotops.bar_colors(1,:);
xtickangle(gca, plotops.x_tick_angle); 
set(gca,'XTickLabels', cellstr(num2str([1:nclusts]')))
set(gca,'XColor',[0 0 0]);
set(gca,'YColor',[0 0 0]);
set(gca,'Box','off')
set(gca,'linewidth', plotops.axes_line_width)
set(gca,'FontSize', plotops.axis_font_size)
set(gca,'FontWeight', plotops. axes_numbers_bold)
set(gca,'FontName', plotops.font)
set(gca,'YTick',[0:.25:1])
xlim(plotops.xlimits);
ylim(plotops.ylimits); 
h=gca; h.XAxis.TickLength = plotops.xticklength;
hxlabel = xlabel('Cluster');
hylabel = ylabel(plotops.ylabel);
    hylabel.Position = plotops.ylabel_position;

 % error bars
 %%% use binomial distribution; equation from Alfonso Nieto-Castanon
ebar_lims = NaN(nclusts,2);
p_binotest = NaN(nclusts,1); 
 for iclust = 1:nclusts
     X = left_n_per_clust(iclust); 
    N =  n_per_clust(iclust); 
    alpha= 0.00001 : 0.00001 : 0.99999; 
    p=binocdf(X,N,alpha); 
    ebar_lims(iclust,:) = alpha([find(p>.975,1,'last'),find(p<.025,1,'first')]); 
    p_binotest(iclust) = 2 * binocdf(X, N, proportion_left_overall);
 end
 hold on
 ebar_neg =  left_prop_by_clust - ebar_lims(:,1); 
 ebar_pos =  -left_prop_by_clust + ebar_lims(:,2); 
 h_ebar = errorbar([1:nclusts]', left_prop_by_clust, ebar_neg, ebar_pos,'--');
    h_ebar.LineWidth = 0.8;
    h_ebar.LineStyle = 'none';
    h_ebar.Color = [0 0 0];
    
h_yline = yline(proportion_left_overall, 'LineStyle',plotops.yline_style, 'LineWidth',plotops.yline_width, 'Color',plotops.yline_color);

% % % % % % % % % hleg = legend({' Left hemisphere',' Right hemisphere',''});
% % % % % % % % % hleg.LineWidth = 1;
% % % % % % % % % hleg.FontWeight = 'Normal';
% % % % % % % % % hleg.Position =  [0.76 .89 0.23 0.07;];
% % % % % % % % % hleg.EdgeColor = [1 1 1 ]; % color of border around legend

[tbl,chi2,p] = crosstab(left_n_per_clust, n_per_clust)

set(gca,'LooseInset',get(gca,'TightInset')+[0.07 0 0.2 0]) % crop borders... run after positioning ylabel

% save fig
if  plotops.save_fig
    print(hfig, plotops.save_fig_filename, '-dpng', ['-r', num2str(plotops.output_resolution)]); % save the image to file
end

%%  plot consonant vs vowel vs word, right vs left
clear plotops

 plotops.save_fig = 1; 
    plotops.save_fig_filename = [fileparts(topelc_data_filename) filesep 'cons_vow_syl_lateralization_bars'];
    plotops.output_resolution = 300;

% % % % plotops.ylimits = [0, 0.55];
plotops.xlimits = [0.2, 3.7];
plotops.leg_location = 'east';
plotops.yline_width = 2;
    plotops.yline_style = '--';
    plotops.yline_color =  [0.15 0.15 0.15];
plotops.annot_pos_xy =  [0.70, 0.78]; % position of pval annotation
plotops.bar_border_width =  2;
plotops.bar_colors =  [1 0 0; ...
                      0 1 0;...
                      0 0 1]; 
plotops.axes_line_width =  2;
plotops.axis_font_size =  13;
plotops.axes_numbers_bold =  'bold';
plotops.font =  'Arial';
plotops.fig_width_length =  [900 600];
plotops.xticklength = [0 0]; 
plotops.x_tick_angle =  0; % in degrees; 0=straight; positive rotates counter-clockwise
plotops.background_color =  [1 1 1]; 

n_elc_cons_right = nnz(~isnan(elc_cons.right_hemi));
n_elc_cons_left = nnz(isnan(elc_cons.right_hemi));
n_elc_vow_right = nnz(~isnan(elc_vow.right_hemi));
n_elc_vow_left = nnz(isnan(elc_vow.right_hemi));
n_elc_word_right = nnz(~isnan(elc_word.right_hemi));
n_elc_word_left = nnz(isnan(elc_word.right_hemi));
prop_elc_cons_left = n_elc_cons_left / n_elcs; % lateralization as proportion of all electrodes
prop_elc_vow_left = n_elc_vow_left / n_elcs; % lateralization as proportion of all electrodes
prop_elc_word_left = n_elc_word_left / n_elcs; % lateralization as proportion of all electrodes

close all
hfig = figure; 
hfig.Color = plotops.background_color;
set(hfig,'Renderer', 'painters', 'Position', [50, 50, plotops.fig_width_length(1), plotops.fig_width_length(2)])

vals_to_plot = [prop_elc_cons_left, prop_elc_vow_left, prop_elc_word_left];
hbar = bar(vals_to_plot);
hbar.LineWidth = plotops.bar_border_width;
hbar.FaceColor = 'flat';
for ibar = 1:size(hbar.CData,1)
    hbar.CData(ibar,:) = plotops.bar_colors(ibar,:);
end

set(hfig,'Renderer', 'painters', 'Position', [50, 50, plotops.fig_width_length(1), plotops.fig_width_length(2)])
xtickangle(gca, plotops.x_tick_angle); 
hax = gca; 
set(gca,'XTickLabels',{'Consonant', 'Vowel', 'Syllable'})
set(gca,'XColor',[0 0 0]);
set(gca,'YColor',[0 0 0]);
set(gca,'Box','off')
set(gca,'linewidth', plotops.axes_line_width)
set(gca,'FontSize', plotops.axis_font_size)
set(gca,'FontWeight', plotops. axes_numbers_bold)
set(gca,'FontName', plotops.font)
% set(gca,'YTick',[0:.25:1])
h=gca; h.XAxis.TickLength = plotops.xticklength;
xlim([plotops.xlimits]);
hylabel = ylabel({'Fraction of top electrodes','in left hemisphere'});
    hylabel.Position = [-0.08 .125 -1];


 % error bars
 %%% use binomial distribution; equation from Alfonso Nieto-Castanon
alpha= 0.00001 : 0.00001 : 0.99999; 
n_top_elc = length(round(n_elcs*[1-top_proportion_electrodes]) : n_elcs); 
p=binocdf(n_elc_cons_left, n_top_elc, alpha); 
ebar_cons= top_proportion_electrodes * alpha([find(p>.975,1,'last'),find(p<.025,1,'first')]); 
p=binocdf(n_elc_vow_left, n_top_elc, alpha); 
ebar_vow= top_proportion_electrodes * alpha([find(p>.975,1,'last'),find(p<.025,1,'first')]); 
p=binocdf(n_elc_word_left, n_top_elc, alpha); 
ebar_word= top_proportion_electrodes * alpha([find(p>.975,1,'last'),find(p<.025,1,'first')]); 

 hold on
 ebar_neg =  [prop_elc_cons_left - ebar_cons(1); prop_elc_vow_left - ebar_vow(1); prop_elc_word_left - ebar_word(1)]; 
 ebar_pos =  [-prop_elc_cons_left + ebar_cons(2); -prop_elc_vow_left + ebar_vow(2); -prop_elc_word_left + ebar_word(2)];
 h_ebar = errorbar([1,2,3], vals_to_plot, ebar_neg, ebar_pos,'--');
    h_ebar.LineWidth = 0.8;
    h_ebar.LineStyle = 'none';
    h_ebar.Color = [0 0 0];


onset_aligned_is_left = isnan(elc.right_hemi(elc.type==1));
topelc_left_chance = mean(onset_aligned_is_left) * top_proportion_electrodes; % chance level of proportion top electrodes left
h_yline = yline(topelc_left_chance, 'LineStyle',plotops.yline_style, 'LineWidth',plotops.yline_width, 'Color',plotops.yline_color);

% % % % % % % % % % hleg = legend({' Left hemisphere',' Right hemisphere',''});
% % % % % % % % % % hleg.LineWidth = 1;
% % % % % % % % % % hleg.FontWeight = 'Normal';
% % % % % % % % % % hleg.Position =  [0.76 .89 0.25 0.07;];
% % % % % % % % % % hleg.EdgeColor = [1 1 1 ]; % color of border around legend

% NB: crosstab doesn't work with only 2 observations [e.g. comparing only consonant and word]
[tbl,chi2,p] = crosstab([n_elc_cons_left, n_elc_word_left]', [n_top_elc, n_top_elc]'); 

% save fig
if  plotops.save_fig
    print(hfig, plotops.save_fig_filename, '-dpng', ['-r', num2str(plotops.output_resolution)]); % save the image to file
end



