 %%%% scatterplot top encoding proportion against a continuous cluster variable
 %.... including errorbars
 %.... then perform logistic regression
clear
 close all
 
set_paths()
topelc_data_filename = [DATA_DIR '/topelc_data_to_surf'];
load(topelc_data_filename) % load data to plot

%% parameters
plotops.predictor_var = 'width';
%     plotops.precictor_var = 'width_to_peak';
%     plotops.precictor_var = 'width_from_peak';
% plotops.precictor_var = 'start';
%     plotops.precictor_var = 'peak';
%     plotops.precictor_var = 'end';
% plotops.precictor_var = 'onset';
%     plotops.precictor_var = 'offset';

plotops.save_fig = 1; 
    plotops.save_fig_filename = [fileparts(topelc_data_filename) '/figs/encoding_vs_', plotops.predictor_var];
    plotops.output_resolution = 300;
plotops.ylimits = [0, 0.9];
plotops.xlimits = [600, 1950];
plotops.leg_location = 'east';
plotops.background_color =  [1 1 1]; 
plotops.fig_x_y_width_length =  [50 -350 900 600]; % y coord may have to be changed per computer

% plotops.annot_pos_xy =  [0.70, 0.78]; % position of pval annotation
plotops.axes_line_width =  2;
plotops.axis_font_size =  13;
plotops.axes_numbers_bold =  'bold';
plotops.font =  'Arial';
plotops.fig_x_y_width_height =  [50 50 1600 600]; % y coord may have to be changed per computer
plotops.xticklength = [0 0];
plotops.box_on_off = 'off';
plotops.x_tick_angle =  0; % in degrees; 0=straight; positive rotates counter-clockwise
% plotops.xticktlabels = num2str(1:6);
% plotops.xlabel_position  = [3.600   -0.08   -1];
plotops.yticks = [0:.25:1]; 
plotops.ylabel_position = [360 0.4500 -1];
plotops.background_color =  [1 1 1]; 

% scatterplot parameters
plotops.text_to_scat = cellstr([repmat('Cluster ',nclusts,1), num2str([1:nclusts]')]); % clust names for article
%   plotops.text_to_scat = topelc.clust; %%% old cluster names
xoffset = -100;
    plotops.text_scat_x_offset = xoffset*ones(6,3); % shift text labels rightward this much relative to markers
    plotops.text_scat_x_offset(1,3) = -xoffset; % flip to other side
    plotops.text_scat_x_offset(2,2) = -xoffset; % flip to other side
    plotops.text_scat_x_offset(3,2) = -xoffset; % flip to other side
    plotops.text_scat_x_offset(4,2:3) = -xoffset; % flip to other side|
    plotops.text_scat_x_offset(5,:) = -xoffset; % flip to other side
yoffset = -0.025;
    plotops.text_scat_y_offset = yoffset *ones(6,3); % shift text labels up this much relative to markers
    plotops.text_scat_y_offset(1,3) = -yoffset; % flip to other side
    plotops.text_scat_y_offset(2,1:2) = -yoffset; % flip to other side
    plotops.text_scat_y_offset(3,2) = -yoffset; % flip to other side
    plotops.text_scat_y_offset(4,2:3) = -yoffset; % flip to other side
    plotops.text_scat_y_offset(5,1:2) = -yoffset; % flip to other side
plotops.text_fontweight = 'bold';
plotops.text_scat_fontsize = 10; 
plotops.marker_size = 42; 
plotops.marker_color = [0 0 0];

    
plotops.title_fontsize = 14; 
plotops.title_fontweight = 'bold';
%     plotops.title_fontweight = 'normal';    

% plotops.yline_width = 2;
%     plotops.yline_style = '--';
%     plotops.yline_color =  [0.15 0.15 0.15];

plotops.trend_width = 2; 
plotops.trend_color = [0.4 0.4 1]; 
plotops.trend_style = '--';

plotops.ebar_line_width = 0.5;
plotops.ebar_line_style = 'none';
plotops.ebar_color = [0 0 0];

 feats = {'cons', 'vow', 'word'};
    featlabels = {'Consonant', 'Vowel', 'Syllable'};
    nfeats = length(feats);

    set(0,'DefaultFigureWindowStyle','normal')
%     set(0,'DefaultFigureWindowStyle','docked')
    
    
%% organize data
n_elcs = height(elc);

% assign predictor var values to electrode table
for iclust = 1:nclusts
    matchrows = strcmp(elc.cluster_name, topelc.clust{iclust});
    elc{matchrows, plotops.predictor_var} = topelc{iclust, plotops.predictor_var};
end

%% scatterplots
hfig = figure;
hfig.Color = plotops.background_color;
set(hfig,'Renderer', 'painters', 'Position', [plotops.fig_x_y_width_height ])
for ifeat = 1:nfeats
    thisfeat = feats{ifeat}; 
        thisfeatlabel = featlabels{ifeat}; 
    hsubplot(ifeat) = subplot(1,nfeats,ifeat);
    
    tscat(ifeat) = textscatter(topelc{:,plotops.predictor_var} + plotops.text_scat_x_offset(:,ifeat), ...
        topelc{:,[thisfeat,'_prop']} + plotops.text_scat_y_offset(:,ifeat), plotops.text_to_scat);
        tscat(ifeat).TextDensityPercentage = 100; % don't replace text with dots
        tscat(ifeat).FontName = plotops.font;
        tscat(ifeat).FontSize = plotops.text_scat_fontsize;
        tscat(ifeat).FontWeight = plotops.text_fontweight; 
    
    hold on
    hscat(ifeat) = scatter(topelc{:,plotops.predictor_var}, topelc{:,[thisfeat,'_prop']});
        hscat(ifeat).MarkerFaceColor = plotops.marker_color;
        hscat(ifeat).MarkerEdgeColor = plotops.marker_color;
        hscat(ifeat).SizeData = plotops.marker_size; 
        
    hax(ifeat) = gca; 
    hax(ifeat).XTickLabelRotation = plotops.x_tick_angle; 
    set(gca,'Box',plotops.box_on_off)
    set(gca,'linewidth', plotops.axes_line_width)
    set(gca,'FontSize', plotops.axis_font_size)
    set(gca,'FontWeight', plotops. axes_numbers_bold)
    set(gca,'FontName', plotops.font)
    set(gca,'YTick',plotops.yticks)
    xlim([plotops.xlimits]);
    ylim(plotops.ylimits); 
    h=gca; h.XAxis.TickLength = plotops.xticklength;
    yticklabs = hax(ifeat).YTick; % save for later
    hax(ifeat).YTickLabels = '';

    xlab = [upper(plotops.predictor_var(1)), plotops.predictor_var(2:end)]; % capitalize
    hxlabel(ifeat) = xlabel(xlab); 
%         hxlabel(ifeat).Position = plotops.xlabel_position;
%     hylabel(ifeat) = ylabel({['Proportion of top ',thisfeatlabel,'-encoding electrodes']});
%         hylabel(ifeat).Position = plotops.ylabel_position;

    % trendline; used linear fit, weighted by number of electrodes in each cluster
    [trend_p,trend_S,trend_mu] = polyfit(elc{:,plotops.predictor_var},elc{:,['top_',thisfeat,'_coder']},1);
    trend_x = xlim;
    trend_y = polyval(trend_p,trend_x,trend_S,trend_mu);
    htrend = plot(trend_x,trend_y);
        htrend.LineWidth = plotops.trend_width; 
        htrend.Color = plotops.trend_color; 
        htrend.LineStyle = plotops.trend_style;


    
    htitle(ifeat) = title(thisfeatlabel);
        htitle(ifeat).FontSize = plotops.title_fontsize; 
        htitle(ifeat).FontWeight = plotops.title_fontweight;
    
end
hax(1).YTickLabels = yticklabs;
hax(1).YLabel.String = 'Proportion of top encoding electrodes';
    hax(1).YLabel.Position = plotops.ylabel_position


