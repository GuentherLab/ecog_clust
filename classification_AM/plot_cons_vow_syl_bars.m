 % plot top encoding electrodes for consonant, vowel, and syllable in a combined bar graph
%
% updated by AM 2022/7/20
clear
set_paths()

 %% params
topelc_data_filename = [ROOT_DIR, filesep, 'projectnb/busplab/Experiments/ECoG_Preprocessed_AM/topelc_data_to_surf'];
 load_ops.top_proportion_electrodes = 0.3; %%%% will be ignored if we load from topel_data_filename

 plotsops.save_fig = 1; 
    plotops.save_fig_filename = [fileparts(topelc_data_filename) filesep 'cons_vow_syl_topelc_bars'];
    plotops.output_resolution = 300;
 plotops.ylimits = [0, 1];
plotops.xlimits = [0.3, 7];
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
plotops.fig_x_y_width_length =  [50 -350 900 600]; % y coord may have to be changed per computer
plotops.xticklength = [0 0];
plotops.box_on_off = 'off';
plotops.x_tick_angle =  0; % in degrees; 0=straight; positive rotates counter-clockwise
% plotops.xticktlabels = num2str(1:6);
plotops.xlabel_position  = [3.600   -0.08   -1];
plotops.yticks = [0:.25:1]; 
plotops.ylabel_position = [-0.4 0.4 0.5];
plotops.background_color =  [1 1 1]; 

plotops.legend_position = [0.8 .89 0.25 0.0;]; % x,y,width,height
plotops.leg_border_color = [1 1 1]; % color of border around legend

plotops.ebar_line_width = 0.5;
plotops.ebar_line_style = 'none';
plotops.ebar_color = [0 0 0];

%% load data
% % % % % alternative: load data from topelc_data_to_surf.m
% % % % [elc, topelc, clustlist, n_elcs, nclusts] = load_top_encoders(load_ops);

load(topelc_data_filename)

%% make plot
nclusts = height(topelc);
close all
hfig = figure;
yvals = [topelc.cons_prop, topelc.vow_prop, topelc.word_prop];
hbar = bar(yvals);

hfig.Color = plotops.background_color;
set(hfig,'Renderer', 'painters', 'Position', [plotops.fig_x_y_width_length ])
hbar(1).LineWidth = plotops.bar_border_width; hbar(2).LineWidth = plotops.bar_border_width; hbar(3).LineWidth = plotops.bar_border_width; 
for ibar = 1:length(hbar)
    hbar(ibar).FaceColor = plotops.bar_colors(ibar,:);
end

xtickangle(gca, plotops.x_tick_angle); 
% set(gca,'XTickLabels', plotops.xticktlabels)
% set(gca,'XColor',[0 0 0]);
% set(gca,'YColor',[0 0 0]);
set(gca,'Box',plotops.box_on_off)
set(gca,'linewidth', plotops.axes_line_width)
set(gca,'FontSize', plotops.axis_font_size)
set(gca,'FontWeight', plotops. axes_numbers_bold)
set(gca,'FontName', plotops.font)
set(gca,'YTick',plotops.yticks)
xlim([plotops.xlimits]);
ylim(plotops.ylimits); 
h=gca; h.XAxis.TickLength = plotops.xticklength;
hxlabel = xlabel({'Cluster ID'}); 
    hxlable.Position = plotops.xlabel_position;
hylabel = ylabel({'Proportion of top-30% electrodes'});
    hylabel.Position = plotops.ylabel_position;

% error bars
hold on

ee = nan(3,nclusts);
for i = 1:3
    ee(i,:) = hbar(i).XEndPoints;
end
ebar_neg = yvals - [topelc.cons_ebar(:,1), topelc.vow_ebar(:,1), topelc.word_ebar(:,1)];
ebar_pos = -yvals + [topelc.cons_ebar(:,2), topelc.vow_ebar(:,2), topelc.word_ebar(:,2)];
h_ebar = errorbar(ee',yvals,ebar_neg,ebar_pos);
    for i_ebar = 1:length(h_ebar)
        h_ebar(i_ebar).LineWidth = plotops.ebar_line_width; 
        h_ebar(i_ebar).LineStyle = plotops.ebar_line_style;
        h_ebar(i_ebar).Color = plotops.ebar_color; 
    end

% line representing chance proportion of top electrodes
h_yline = yline(load_ops.top_proportion_electrodes,...
    'LineStyle',plotops.yline_style, 'LineWidth',plotops.yline_width, 'Color',plotops.yline_color);

% add legend
hleg = legend({'consonant','vowel','syllable'}); 
hleg.LineWidth = 1;
hleg.FontWeight = 'Normal';
hleg.Position = plotops.legend_position;
hleg.EdgeColor = plotops.leg_border_color; 

% save fig
if  plotsops.save_fig
    print(hfig, plotops.save_fig_filename, '-dpng', ['-r', num2str(plotops.output_resolution)]); % save the image to file
end
    
    
    
    