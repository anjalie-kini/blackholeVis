%%Anjalie Kini
%%CSC600

function blackHoleSimulation
import mlreportgen.dom.*

fig = figure('Name','Blackhole Light Path Animation','position',[100 300 1200 600]);
%axes('XLim', [-4 4], 'units','pixels','position',[50 50 500 500], 'NextPlot', 'add');

title('Black Hole Simulation', 'FontSize', 22)

   rayTracingFunction(1,1,0.6);

ax1pos = get(gca,'position');
ax1pos_adjusted = [-.06    0.1100    0.7750    0.8150];
set(gca,'position',ax1pos_adjusted)

% Note about pressing generate button to redraw
titleNote = annotation('textbox');
titleNote.Position = [0.01, .91, 0.50, 0.08];
titleNote.String = ("Black Hole Light Path Simulation");
titleNote.FontSize = 24;
titleNote.EdgeColor = 'none';

UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 14);
generateButton = uicontrol(fig, 'style', 'pushbutton');
generateButton.Position = [1095 62 80 40];
generateButton.String = 'Generate!';
generateButton.Callback = @buttonPushed;

% Note about pressing generate button to redraw
generateNote = annotation('textbox');
generateNote.Position = [0.65, .107, 0.27, 0.04];
generateNote.String = ("(Press Generate! to redraw simulation with new parameters)");
generateNote.FontSize = 11.5;
generateNote.EdgeColor = 'none';

% Indicates whether simulation is finished loading
loading = annotation('textbox');
loading.Position = [.65 .92 .15 .07];
loading.String = ("");
loading.FontSize = 17;
loading.EdgeColor = 'none';

    function buttonPushed(src,event)
        loading.String = ("Loading...");
        pause(0.001);
        rayTracingFunction(massSlider.Value, spinSlider.Value, gravSlider.Value);
        loading.String = ("Generation completed");
    end

% Button group of radio buttons - Kerr vs. Schwarschild blackholes
% (right now type of blackhole selected is recorded but does not affect the
% simulation on screen)
blackholeType = uibuttongroup(fig, 'Visible','off');
blackholeType.Position = [.65 .75 .33 .16];
blackholeType.SelectionChangedFcn = @bselection;
blackholeType.Title = 'Select type of blackhole';
blackholeType.TitlePosition = 'centerTop';
blackholeType.FontSize = 12;
blackholeType.BackgroundColor = [0.745 0.745 .745];

kerrBH = uicontrol(blackholeType, 'style', 'radiobutton');
kerrBH.String = 'Kerr blackhole (rotating)';
kerrBH.Position = [20 40 400 30];
kerrBH.BackgroundColor = [0.745 0.745 .745];

schwarzschildBH = uicontrol(blackholeType, 'style', 'radiobutton');
schwarzschildBH.String = 'Schwarzschild blackhole (non-rotating)';
schwarzschildBH.Position = [20 10 400 30];
schwarzschildBH.BackgroundColor = [0.745 0.745 .745];

% Note about pressing generate button to redraw
typeNote = annotation('textbox');
typeNote.Position = [.65 .588 .33 .16];
typeNote.String = ("(Currently the Schwarzschild model is not yet finished -- only the Kerr model works)");
typeNote.FontSize = 10;
typeNote.EdgeColor = 'none';

blackholeType.Visible = 'on';
% blackHoleMarker = 1 -- Kerr
% blackHoleMarker = -1 -- Schwarzschild
blackHoleMarker = 1;

    function bselection(source,event)
       display(['Previous: ' event.OldValue.String]);
       display(['Current: ' event.NewValue.String]);
       display('------------------');
       blackHoleMarker = blackHoleMarker * -1;
    end

mass = 1;
spin = 0.6;
grav = 1;

% mass slider 
massPanel = uipanel(fig);
massPanel.Position = [.65 .56 .33 .16];
massPanel.Title = 'Mass'
massPanel.FontSize = 14;
massPanel.TitlePosition = 'centerTop'
%massPanel.BackgroundColor = [0.5 0.5 0.5];
massSlider = uicontrol(massPanel,'Style','slider');
massSlider.Value = 1;
massSlider.Position = [20 20 360 20];
massSlider.Min = 0;
massSlider.Max = 5;
massPanel.Title = "Mass = " + massSlider.Value;
massSlider.BackgroundColor = [0.745 0.745 0.745]
addlistener(massSlider, 'Value', 'PostSet', @callbackmassfn);

% shows initial value of slider (updated in callback function)
%massValue = annotation('textbox');
%massValue.Position = [0.01, .95, 0.16, 0.04];
%massValue.String = ("Mass slider value: " + massSlider.Value);
%massValue.FontSize = 15;

    function callbackmassfn(source, eventdata)
        mass = get(eventdata.AffectedObject, 'Value');
        %testBH(mass,spin,grav);
        TextH.String = num2str(mass);
        massPanel.Title = "Mass = " + massSlider.Value;
        %massValue.String = ("Mass slider value: " + massSlider.Value);
    end

% spin slider
spinPanel = uipanel(fig);
spinPanel.Position = [.65 .37 .33 .16];
spinPanel.Title = 'Spin'
spinPanel.FontSize = 14;
spinPanel.TitlePosition = 'centerTop'
%spinPanel.BackgroundColor = [0.5 0.5 0.5];
spinSlider = uicontrol(spinPanel,'Style','slider');
spinSlider.Value = 0.6;
spinSlider.Position = [20 20 360 20];
spinSlider.Min = 0;
spinSlider.Max = 1;
spinPanel.Title = "Spin = " + spinSlider.Value;
spinSlider.BackgroundColor = [0.745 0.745 0.745]
addlistener(spinSlider, 'Value', 'PostSet', @callbackchargefn); 

% shows initial value of slider (updated in callback function)
%spinValue = annotation('textbox');
%spinValue.Position = [0.01, .90, 0.16, 0.04];
%spinValue.String = ("Spin slider value: " + spinSlider.Value);
%spinValue.FontSize = 15;

    function callbackchargefn(source, eventdata)
        spin = get(eventdata.AffectedObject, 'Value');
        %testBH(mass,spin,grav);
        TextH.String = num2str(spin);
        spinPanel.Title = "Spin = " + spinSlider.Value;
        %spinValue.String = ("Spin slider value: " + spinSlider.Value);
    end

% grav slider
gravPanel = uipanel(fig);
gravPanel.Position = [.65 .18 .33 .16];
gravPanel.Title = 'Gravitational Constant'
gravPanel.FontSize = 14;
gravPanel.TitlePosition = 'centerTop'
%gravPanel.BackgroundColor = [0.5 0.5 0.5];
gravSlider = uicontrol(gravPanel,'Style','slider');
gravSlider.Value = 1;
gravSlider.Position = [20 20 360 20];
gravSlider.Min = 0;
gravSlider.Max = 5;
gravPanel.Title = "Gravitation = " + gravSlider.Value;
gravSlider.BackgroundColor = [0.745 0.745 0.745]
addlistener(gravSlider, 'Value', 'PostSet', @callbackspinfn); 

% shows initial value of slider (updated in callback function)
%gravValue = annotation('textbox');
%gravValue.Position = [0.01, .85, 0.16, 0.04];
%gravValue.String = ("Grav slider value: " + gravSlider.Value);
%gravValue.FontSize = 15;


    function callbackspinfn(source, eventdata)
        grav = get(eventdata.AffectedObject, 'Value');
        %testBH(mass,spin,grav);
        TextH.String = num2str(grav);
        gravPanel.Title = "Gravitation = " + gravSlider.Value;
        %gravValue.String = ("Grav slider value: " + gravSlider.Value);
    end

% Note about pressing generate button to redraw
radiusNote = annotation('textbox');
radiusNote.Position = [0.65, .052, 0.34, 0.04];
radiusNote.String = ("Gravitation and Mass are two parameters directly proportional to the radius of the black hole. Increasing either will increase the gravitational pull or curvature of spacetime around the blackhole. Spin is angular momentum.");
radiusNote.FontSize = 11.5;
radiusNote.EdgeColor = 'none';

% externalLink Object currently links to 538 - will eventually link to
% accompanying website
d = Document('mydoc');
append(d,ExternalLink('https://anjalie-kini.github.io/blackholeVis/','blackHoleVis site'));
close(d);

% button serves as a link to website when pushed
UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize');
set(0, 'DefaultUIControlFontSize', 14);
link = uicontrol(fig, 'style', 'pushbutton');
link.Position = [1000 560 175 40];
link.String = 'BlackHoleVis Website';
link.Callback = @buttonPushedLink

    function buttonPushedLink(src,event)
        rptview('mydoc','html');
    end
end
