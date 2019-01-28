%%Anjalie Kini
%%CSC600

function blackholeSlider
import mlreportgen.dom.*

fig = figure('Name','Blackhole Light Path Animation','position',[100 300 1000 600]);
axes('XLim', [-4 4], 'units','pixels','position',[50 50 500 500], 'NextPlot', 'add');

% initial model drawn with average values of sliders assumed
testBH(.25,4,15);

title('Sample Plot (Not Geodesic Equations)', 'FontSize', 22)

% "Generate!" button at bottom of plot - redraws plot with randomly
% generated parameters when pushed

UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 14);
generateButton = uicontrol('style', 'pushbutton');
generateButton.Position = [750 40 80 40];
generateButton.String = 'Generate!';
generateButton.Callback = @buttonPushed

    function buttonPushed(src,event)
        testBH(rand, rand + 3, rand * 20);
    end

% Button group of radio buttons - Kerr vs. Schwarschild blackholes
% (right now type of blackhole selected is recorded but does not affect the
% simulation on screen)
blackholeType = uibuttongroup('Visible','off');
blackholeType.Position = [.575 .73 .4 .16];
blackholeType.SelectionChangedFcn = @bselection;
blackholeType.Title = 'Select type of blackhole'
blackholeType.TitlePosition = 'centerTop'

kerrBH = uicontrol(blackholeType, 'style', 'radiobutton');
kerrBH.String = 'Kerr blackhole (rotating)';
kerrBH.Position = [20 40 400 30];

schwarzschildBH = uicontrol(blackholeType, 'style', 'radiobutton');
schwarzschildBH.String = 'Schwarzschild blackhole (non-rotating)';
schwarzschildBH.Position = [20 10 400 30];

blackholeType.Visible = 'on';
% blackHoleMarker = 1 -- Kerr
% blackHoleMarker = -1 -- Schwarzschild
blackHoleMarker = 1;

    function bselection(source,event)
       display(['Previous: ' event.OldValue.String]);
       display(['Current: ' event.NewValue.String]);
       display('------------------');
       blackHoleMarker = blackHoleMarker * 1;
    end

maxBH = 3.5;
minBH = 0.5;
numberBH = 10;

% mass slider - currently controls the minimum/ starting position of the
% light paths (must be between 0 and 1)
massPanel = uipanel(fig);
massPanel.Position = [.575 .54 .4 .16];
massPanel.Title = 'Mass'
massPanel.FontSize = 14;
massPanel.TitlePosition = 'centerTop'
massSlider = uicontrol(massPanel,'Style','slider');
massSlider.Value = 0.5;
massSlider.Position = [20 20 360 20];
massSlider.Min = 0;
massSlider.Max = 1;
addlistener(massSlider, 'Value', 'PostSet', @callbackmassfn);

% shows initial value of slider (updated in callback function)
massValue = annotation('textbox');
massValue.Position = [0.32, 0.23, 0.2, 0.04];
massValue.String = ("Mass slider value: " + massSlider.Value);
massValue.FontSize = 15;

    function callbackmassfn(source, eventdata)
        minBH = get(eventdata.AffectedObject, 'Value');
        testBH(minBH,maxBH,numberBH);
        TextH.String = num2str(minBH);
        
       massValue.String = ("Mass slider value: " + massSlider.Value);
    end

% charge slider - currently controls the maximum/ ending position of the
% light paths (must be between 3 and 4)
chargePanel = uipanel(fig);
chargePanel.Position = [.575 .35 .4 .16];
chargePanel.Title = 'Charge'
chargePanel.FontSize = 14;
chargePanel.TitlePosition = 'centerTop'
chargeSlider = uicontrol(chargePanel,'Style','slider');
chargeSlider.Value = 3.5;
chargeSlider.Position = [20 20 360 20];
chargeSlider.Min = 3;
chargeSlider.Max = 4;
addlistener(chargeSlider, 'Value', 'PostSet', @callbackchargefn); 

% shows initial value of slider (updated in callback function)
chargeValue = annotation('textbox');
chargeValue.Position = [0.32, 0.18, 0.2, 0.04];
chargeValue.String = ("Charge slider value: " + chargeSlider.Value);
chargeValue.FontSize = 15;

    function callbackchargefn(source, eventdata)
        maxBH = get(eventdata.AffectedObject, 'Value');
        testBH(minBH,maxBH,numberBH);
        TextH.String = num2str(maxBH);
        
        chargeValue.String = ("Charge slider value: " + chargeSlider.Value);
    end

% spin slider - currently controls the number of light paths being drawn
% (must be between 0 and 20)
spinPanel = uipanel(fig);
spinPanel.Position = [.575 .16 .4 .16];
spinPanel.Title = 'Spin'
spinPanel.FontSize = 14;
spinPanel.TitlePosition = 'centerTop'
spinSlider = uicontrol(spinPanel,'Style','slider');
spinSlider.Value = 10;
spinSlider.Position = [20 20 360 20];
spinSlider.Min = 0;
spinSlider.Max = 20;
addlistener(spinSlider, 'Value', 'PostSet', @callbackspinfn); 

% shows initial value of slider (updated in callback function)
spinValue = annotation('textbox');
spinValue.Position = [0.32, 0.13, 0.2, 0.04];
spinValue.String = ("Spin slider v4alue: " + spinSlider.Value);
spinValue.FontSize = 15;


    function callbackspinfn(source, eventdata)
        numberBH = get(eventdata.AffectedObject, 'Value');
        testBH(minBH,maxBH,numberBH);
        TextH.String = num2str(numberBH);
        
        spinValue.String = ("Spin slider value: " + spinSlider.Value);
    end

% externalLink Object currently links to 538 - will eventually link to
% accompanying website
d = Document('mydoc');
append(d,ExternalLink('https://www.fivethirtyeight.com/','The link you desire!'));
close(d);

% button serves as a link to website when pushed
UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 14);
link = uicontrol('style', 'pushbutton');
link.Position = [900 560 100 40];
link.String = 'Click here!';
link.Callback = @buttonPushedLink

    function buttonPushedLink(src,event)
        rptview('mydoc','html');
    end
end
