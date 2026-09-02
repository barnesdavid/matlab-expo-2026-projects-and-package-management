classdef FlightSensorApp < matlab.apps.App

    % Used to locate and load the app's XML configuration file
    properties (Access = public, Constant)
        AppConfigFilename = './FlightSensorApp.xml'; % File path to the app configuration file containing component layout and settings
    end

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        MainGrid                        matlab.ui.container.GridLayout
        ResultsTabGroup                 matlab.ui.container.TabGroup
        DataTab                         matlab.ui.container.Tab
        DataGrid                        matlab.ui.container.GridLayout
        DataTable                       matlab.ui.control.Table
        PlotTab                         matlab.ui.container.Tab
        PlotGrid                        matlab.ui.container.GridLayout
        MainAxes                        matlab.ui.control.UIAxes
        ChartTab                        matlab.ui.container.Tab
        ChartGrid                       matlab.ui.container.GridLayout
        ExploreSummaryLabel             matlab.ui.control.Label
        ExploreControlGrid              matlab.ui.container.GridLayout
        XVariableDropDown               matlab.ui.control.DropDown
        XVariableLabel                  matlab.ui.control.Label
        PlotTypeDropDown                matlab.ui.control.DropDown
        PlotTypeLabel                   matlab.ui.control.Label
        ExploreAxes                     matlab.ui.control.UIAxes
        ChartHostPanel                  matlab.ui.container.Panel
        ModelTab                        matlab.ui.container.Tab
        ModelGrid                       matlab.ui.container.GridLayout
        ModelSummaryLabel               matlab.ui.control.Label
        ModelAxes                       matlab.ui.control.UIAxes
        ControlPanel                    matlab.ui.container.Panel
        ControlGrid                     matlab.ui.container.GridLayout
        StatusLabel                     matlab.ui.control.Label
        FitModelButton                  matlab.ui.control.Button
        ExploreDataButton               matlab.ui.control.Button
        CleanDataButton                 matlab.ui.control.Button
        PlotDataButton                  matlab.ui.control.Button
        SelectDataButton                matlab.ui.control.Button
        DataFileEditField               matlab.ui.control.EditField
        DataFileEditFieldLabel          matlab.ui.control.Label
        LoadDataButton                  matlab.ui.control.Button
        FileLabel                       matlab.ui.control.Label
        TitleLabel                      matlab.ui.control.Label
    end

    properties (Access = private)
        RawData table
        CleanData table
        ActiveFile string = ""
        VirtualSensorModel = struct.empty
        PredictorNames string = ["FuelQuantity", "OilPressure", "OilTemperature", "Altitude", ...
            "ExhaustTemperature", "FuelFlow", "FanSpeed", "WindDirection", "WindSpeed"]
        TrendSignalNames string = ["TrueAirSpeed", "Altitude", "FuelFlow", "FanSpeed", ...
            "OilPressure", "OilTemperature", "ExhaustTemperature", "WindSpeed"]
        ExploreChart = []
        ChartExamplesAvailable (1,1) logical = false
    end

    properties (Access = public)
        ShowAlerts (1,1) logical = true
    end

    methods (Access = private)
        function root = projectRoot(~)
            project = currentProject;
            root = string(project.RootFolder);
        end

        function loadSelectedData(app, workbookFile)
            workbookFile = string(workbookFile);
            if strlength(workbookFile) == 0
                error("flightDemo:MissingFileSelection", "Enter or select a flight data workbook.");
            end

            app.RawData = loadFlightData(workbookFile);
            app.CleanData = table();
            app.VirtualSensorModel = struct.empty;
            app.ActiveFile = workbookFile;
            app.DataFileEditField.Value = char(workbookFile);
            app.FileLabel.Text = "File: " + string(app.getFileName(workbookFile));
            app.showTablePreview(app.RawData);
            app.ResultsTabGroup.SelectedTab = app.DataTab;
            app.setStatus(sprintf("Loaded %d rows. Use Clean Data to remove ground samples and oil sensor dropouts.", ...
                height(app.RawData)));
        end

        function data = activeData(app)
            if ~isempty(app.CleanData)
                data = app.CleanData;
            else
                data = app.RawData;
            end
        end

        function showTablePreview(app, data)
            if isempty(data)
                app.DataTable.Data = table();
                return
            end

            previewRows = 1:min(200, height(data));
            app.DataTable.Data = data(previewRows, :);
        end

        function plotMainData(app)
            data = app.activeData();
            rows = sampleFlightRows(height(data), 2200);

            cla(app.MainAxes, "reset");
            yyaxis(app.MainAxes, "left");
            plot(app.MainAxes, data.Time(rows), data.OilPressure(rows), ...
                LineWidth=1.4, Color=[0.05 0.33 0.56]);
            ylabel(app.MainAxes, "Oil pressure (psi)");

            yyaxis(app.MainAxes, "right");
            plot(app.MainAxes, data.Time(rows), data.TrueAirSpeed(rows), ...
                LineWidth=1.2, Color=[0.74 0.23 0.16]);
            ylabel(app.MainAxes, "True airspeed (knots)");

            title(app.MainAxes, "Oil pressure and true airspeed");
            xlabel(app.MainAxes, "Time");
            grid(app.MainAxes, "on");
            app.MainAxes.Box = "on";
            app.ResultsTabGroup.SelectedTab = app.PlotTab;
        end

        function modelData = ensureCleanData(app)
            if isempty(app.CleanData)
                [app.CleanData, summary] = cleanFlightData(app.RawData);
                app.showTablePreview(app.CleanData);
                app.setStatus(sprintf("Cleaned data for modeling: %d flight rows, %d ground rows removed, %d oil samples repaired.", ...
                    summary.FlightRows, summary.GroundRowsRemoved, summary.TotalSamplesCleaned));
            end
            modelData = app.CleanData;
        end

        function plotVirtualSensor(app, model, data)
            testRows = model.TestRows;
            testRows = testRows(sampleFlightRows(numel(testRows), 1600));

            cla(app.ModelAxes, "reset");
            plot(app.ModelAxes, data.Time(testRows), data.TrueAirSpeed(testRows), ...
                LineWidth=1.4, Color=[0.05 0.33 0.56]);
            hold(app.ModelAxes, "on");
            plot(app.ModelAxes, data.Time(testRows), model.PredictedTrueAirSpeed(testRows), ...
                LineWidth=1.4, Color=[0.78 0.42 0.08]);
            hold(app.ModelAxes, "off");
            grid(app.ModelAxes, "on");
            app.ModelAxes.Box = "on";
            title(app.ModelAxes, "Virtual sensor: predicted true airspeed");
            xlabel(app.ModelAxes, "Time");
            ylabel(app.ModelAxes, "True airspeed (knots)");
            legend(app.ModelAxes, ["Measured", "Predicted"], Location="southoutside", Orientation="horizontal");

            app.ModelSummaryLabel.Text = sprintf("RMSE: %.1f knots. Strongest predictors: %s.", ...
                model.RMSE, strjoin(model.TopPredictors, ", "));
        end

        function configureExploreControls(app)
            app.PlotTypeDropDown.Items = {'Relationship', 'Trend', 'Prediction check'};
            app.PlotTypeDropDown.Value = 'Relationship';
            app.XVariableDropDown.Items = cellstr(app.PredictorNames);
            app.XVariableDropDown.Value = 'Altitude';
            app.updateExploreControlState();
        end

        function updateChartExamplesButton(app)
            try
                project = currentProject;
                projectDependencies = project.ProjectDependencies;
                if isempty(projectDependencies)
                    dependencyNames = string.empty;
                else
                    dependencyNames = string({projectDependencies.Name});
                end
                packageInfo = mpmlist("chart_examples");
                app.ChartExamplesAvailable = any(dependencyNames == "chart_examples") && ...
                    ~isempty(packageInfo) && packageInfo.Installed;
            catch
                app.ChartExamplesAvailable = false;
            end

            if app.ChartExamplesAvailable
                app.ExploreDataButton.Text = "Explore Data";
                app.ExploreDataButton.FontColor = [0 0 0];
                app.ExploreDataButton.FontSize = 12;
            else
                app.ExploreDataButton.Text = "Install the chart_examples to use explore charts.";
                app.ExploreDataButton.FontColor = [0.75 0.10 0.10];
                app.ExploreDataButton.FontSize = 10;
            end
        end

        function updateExploreControlState(app)
            switch string(app.PlotTypeDropDown.Value)
                case "Trend"
                    app.XVariableLabel.Text = "Signal";
                    app.XVariableLabel.Visible = "on";
                    app.XVariableDropDown.Items = cellstr(app.TrendSignalNames);
                    app.XVariableDropDown.Value = 'TrueAirSpeed';
                    app.XVariableDropDown.Enable = "on";
                    app.XVariableDropDown.Visible = "on";
                    app.ExploreSummaryLabel.Text = "Trend shows the selected signal over time. Color highlights the signal value.";
                case "Prediction check"
                    app.XVariableLabel.Text = "Variable";
                    app.XVariableLabel.Visible = "off";
                    app.XVariableDropDown.Enable = "off";
                    app.XVariableDropDown.Visible = "off";
                    app.ExploreSummaryLabel.Text = "Prediction check compares predicted and measured true airspeed against an ideal 1:1 reference line.";
                otherwise
                    app.XVariableLabel.Text = "Predictor";
                    app.XVariableLabel.Visible = "on";
                    app.XVariableDropDown.Items = cellstr(app.PredictorNames);
                    app.XVariableDropDown.Value = 'Altitude';
                    app.XVariableDropDown.Enable = "on";
                    app.XVariableDropDown.Visible = "on";
                    app.ExploreSummaryLabel.Text = "Relationship uses ScatterFitChart to screen a predictor against true airspeed.";
            end
        end

        function clearExploreChart(app)
            if ~isempty(app.ExploreChart) && isvalid(app.ExploreChart)
                delete(app.ExploreChart);
            end
            app.ExploreChart = [];

            % The prediction view uses these axes while File Exchange charts
            % occupy the same grid cell for the other exploration modes.
            cla(app.ExploreAxes);
            legend(app.ExploreAxes, "off");
            colorbar(app.ExploreAxes, "off");
        end

        function showExploreAxes(app)
            app.clearExploreChart();
            app.ChartHostPanel.Visible = "off";
            app.ExploreAxes.Visible = "on";
        end

        function chartHost = preparePackageChartHost(app)
            app.clearExploreChart();
            app.ExploreAxes.Visible = "off";
            app.ChartHostPanel.Visible = "on";
            chartHost = app.ChartHostPanel;
        end

        function correlationValue = renderRelationshipChart(app, data, xVariable)
            chartHost = app.preparePackageChartHost();

            rows = sampleFlightRows(height(data), 700);
            x = data.(xVariable)(rows);
            y = data.TrueAirSpeed(rows);
            validRows = isfinite(x) & isfinite(y);
            x = x(validRows);
            y = y(validRows);
            correlationValue = app.linearCorrelation(x, y);

            app.ExploreChart = ScatterFitChart("Parent", chartHost, ...
                "XData", x, ...
                "YData", y, ...
                "SizeData", 20, ...
                "Marker", "o", ...
                "LineColor", [0.74 0.23 0.16], ...
                "LineWidth", 2.2, ...
                "Controls", "off");
            app.ExploreChart.LineVisible = abs(correlationValue) >= 0.7;

            legend(app.ExploreChart, "off");
            grid(app.ExploreChart, "on");
            axis(app.ExploreChart, "padded");
            title(app.ExploreChart, app.getVariableLabel(xVariable) + " vs. true airspeed");
            xlabel(app.ExploreChart, app.getVariableLabel(xVariable) + app.getVariableUnits(xVariable));
            ylabel(app.ExploreChart, "True airspeed (knots)");
        end

        function renderTrendChart(app, data, yVariable)
            chartHost = app.preparePackageChartHost();

            rows = sampleFlightRows(height(data), 3000);
            y = data.(yVariable)(rows);
            time = data.Time(rows);
            validRows = isfinite(y) & ~isnat(time);

            app.ExploreChart = LineGradientChart("Parent", chartHost, ...
                "XData", time(validRows), ...
                "YData", y(validRows), ...
                "LineWidth", 4.0);

            colormap(app.ExploreChart, turbo(256));
            trendColorbar = colorbar(app.ExploreChart);
            trendColorbar.Label.String = app.getVariableLabel(yVariable) + app.getVariableUnits(yVariable);
            title(app.ExploreChart, app.getVariableLabel(yVariable) + " across the flight");
            xlabel(app.ExploreChart, "Time");
            ylabel(app.ExploreChart, app.getVariableLabel(yVariable) + app.getVariableUnits(yVariable));
        end

        function renderExploreData(app)
            % Package chart containers must be created after their tab is visible
            % so they receive the final grid dimensions.
            app.ResultsTabGroup.SelectedTab = app.ChartTab;
            data = app.ensureCleanData();
            plotType = string(app.PlotTypeDropDown.Value);

            if plotType == "Prediction check"
                app.showExploreAxes();
                if isempty(app.VirtualSensorModel)
                    app.VirtualSensorModel = fitVirtualSensor(data);
                end
                data.PredictedTrueAirSpeed = app.VirtualSensorModel.PredictedTrueAirSpeed;
                renderExplorePlot(app.ExploreAxes, data, plotType, ...
                    "PredictedTrueAirSpeed", "TrueAirSpeed");
                app.ExploreSummaryLabel.Text = sprintf("Model check: predicted vs. measured true airspeed. RMSE is %.1f knots.", ...
                    app.VirtualSensorModel.RMSE);
            elseif plotType == "Trend"
                app.renderTrendChart(data, string(app.XVariableDropDown.Value));
                app.ExploreSummaryLabel.Text = "File Exchange trend: LineGradientChart colors the selected signal across the flight.";
            else
                xVariable = string(app.XVariableDropDown.Value);
                correlationValue = app.renderRelationshipChart(data, xVariable);
                app.ExploreSummaryLabel.Text = sprintf("ScatterFitChart screen: %s has r = %.2f with true airspeed on cleaned flight rows.", ...
                    app.getVariableLabel(xVariable), correlationValue);
            end
        end

        function setStatus(app, message)
            app.StatusLabel.Text = string(message);
        end

        function reportError(app, titleText, exception)
            app.setStatus(exception.message);
            if app.ShowAlerts
                uialert(app.UIFigure, exception.message, titleText);
            end
        end

        function fileName = getFileName(~, filePath)
            [~, name, extension] = fileparts(filePath);
            fileName = name + extension;
        end

        function label = getVariableLabel(~, variableName)
            labels = dictionary( ...
                ["FuelQuantity", "OilPressure", "OilTemperature", "Altitude", ...
                "ExhaustTemperature", "FuelFlow", "FanSpeed", "WindDirection", ...
                "WindSpeed", "TrueAirSpeed", "PredictedTrueAirSpeed"], ...
                ["Fuel quantity", "Oil pressure", "Oil temperature", "Altitude", ...
                "Exhaust temperature", "Fuel flow", "Fan speed", "Wind direction", ...
                "Wind speed", "True airspeed", "Predicted true airspeed"]);

            if isKey(labels, variableName)
                label = labels(variableName);
            else
                label = variableName;
            end
        end

        function units = getVariableUnits(~, variableName)
            unitsByVariable = dictionary( ...
                ["OilPressure", "OilTemperature", "Altitude", "ExhaustTemperature", ...
                "FuelFlow", "FanSpeed", "WindDirection", "WindSpeed", ...
                "TrueAirSpeed", "PredictedTrueAirSpeed"], ...
                [" (psi)", " (deg F)", " (ft)", " (deg F)", ...
                " (gal/hr)", " (rpm)", " (deg)", " (knots)", ...
                " (knots)", " (knots)"]);

            if isKey(unitsByVariable, variableName)
                units = unitsByVariable(variableName);
            else
                units = "";
            end
        end

        function value = linearCorrelation(~, x, y)
            x = x(:);
            y = y(:);
            if numel(x) < 2 || std(x) == 0 || std(y) == 0
                value = NaN;
            else
                value = corr(x, y, Rows="complete");
            end
        end
    end

    % Callbacks that handle component events
    methods

        % Code that executes after component creation
        function startupFcn(app)
            app.configureExploreControls();
            app.updateChartExamplesButton();
            app.ModelSummaryLabel.Text = "Fit the virtual sensor to compare measured and predicted true airspeed.";

            defaultFile = "FlightData.xlsx";
            app.DataFileEditField.Value = char(defaultFile);
            try
                app.loadSelectedData(defaultFile);
            catch exception
                app.setStatus("Select FlightData.xlsx to begin.");
            end
        end

        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)
            try
                app.loadSelectedData(app.DataFileEditField.Value);
            catch exception
                app.reportError("Unable to load data", exception);
            end
        end

        % Button pushed function: SelectDataButton
        function SelectDataButtonPushed(app, event)
            try
                startLocation = char(app.projectRoot());
                if strlength(app.ActiveFile) > 0 && isfile(app.ActiveFile)
                    startLocation = char(app.ActiveFile);
                end

                [fileName, folderName] = uigetfile({'*.xlsx', 'Excel workbooks (*.xlsx)'}, ...
                    "Select flight data", startLocation);
                if isequal(fileName, 0)
                    return
                end

                app.loadSelectedData(string(folderName) + string(fileName));
            catch exception
                app.reportError("Unable to load data", exception);
            end
        end

        % Button pushed function: PlotDataButton
        function PlotDataButtonPushed(app, event)
            try
                app.plotMainData();
                app.setStatus("Plotted the active flight dataset.");
            catch exception
                app.reportError("Unable to plot data", exception);
            end
        end

        % Button pushed function: CleanDataButton
        function CleanDataButtonPushed(app, event)
            try
                [app.CleanData, summary] = cleanFlightData(app.RawData);
                app.VirtualSensorModel = struct.empty;
                app.showTablePreview(app.CleanData);
                app.plotMainData();
                app.setStatus(sprintf("Cleaned %d oil samples and removed %d ground rows. Table now previews flight-only data.", ...
                    summary.TotalSamplesCleaned, summary.GroundRowsRemoved));
            catch exception
                app.reportError("Unable to clean data", exception);
            end
        end

        % Button pushed function: ExploreDataButton
        function ExploreDataButtonPushed(app, event)
            try
                app.updateChartExamplesButton();
                if ~app.ChartExamplesAvailable
                    error("flightDemo:MissingChartExamples", ...
                        "Install the chart_examples project dependency to explore package charts.");
                end
                app.renderExploreData();
                app.setStatus("Opened the data exploration view.");
            catch exception
                app.reportError("Unable to explore data", exception);
            end
        end

        % Value changed function: PlotTypeDropDown
        function PlotTypeDropDownValueChanged(app, event)
            try
                app.updateExploreControlState();
                if app.ResultsTabGroup.SelectedTab == app.ChartTab && ~isempty(app.RawData)
                    app.renderExploreData();
                    app.setStatus("Updated the data exploration plot.");
                end
            catch exception
                app.reportError("Unable to update exploration controls", exception);
            end
        end

        % Value changed function: XVariableDropDown
        function XVariableDropDownValueChanged(app, event)
            try
                if app.ResultsTabGroup.SelectedTab == app.ChartTab && ~isempty(app.RawData)
                    app.renderExploreData();
                    app.setStatus("Updated the data exploration plot.");
                end
            catch exception
                app.reportError("Unable to update exploration plot", exception);
            end
        end

        % Button pushed function: FitModelButton
        function FitModelButtonPushed(app, event)
            try
                data = app.ensureCleanData();
                app.VirtualSensorModel = fitVirtualSensor(data);
                app.plotVirtualSensor(app.VirtualSensorModel, data);
                app.ResultsTabGroup.SelectedTab = app.ModelTab;
                app.setStatus(sprintf("Fit virtual sensor model with %.1f knot RMSE.", app.VirtualSensorModel.RMSE));
            catch exception
                app.reportError("Unable to fit virtual sensor", exception);
            end
        end
    end

    % App creation
    methods (Access = public)

        % Construct app
        function app = FlightSensorApp(varargin)
            app = app@matlab.apps.App(varargin{:});

            if nargout == 0
                clear app
            end
        end
    end
end
