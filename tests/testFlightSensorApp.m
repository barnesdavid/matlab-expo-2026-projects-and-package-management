classdef testFlightSensorApp < matlab.uitest.TestCase
    %testFlightSensorApp App-level workflow tests for FlightSensorApp.

    properties (Access = private)
        App
    end

    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.App = FlightSensorApp;
            testCase.App.ShowAlerts = false;
        end
    end

    methods (TestMethodTeardown)
        function closeApp(testCase)
            if ~isempty(testCase.App) && isvalid(testCase.App.UIFigure)
                delete(testCase.App.UIFigure);
            end
            testCase.App = [];
        end
    end

    methods (Test)
        function testLoadPlotAndCleanWorkflow(testCase)
            app = testCase.App;

            testCase.verifyEqual(app.ResultsTabGroup.SelectedTab, app.DataTab);
            testCase.verifyGreaterThan(height(app.DataTable.Data), 0);
            testCase.verifySubstring(app.StatusLabel.Text, 'Loaded 47312 rows');

            press(testCase, app.PlotDataButton);
            testCase.verifyEqual(app.ResultsTabGroup.SelectedTab, app.PlotTab);
            testCase.verifyGreaterThanOrEqual(numel(findobj(app.MainAxes, 'Type', 'Line')), 2);

            press(testCase, app.CleanDataButton);
            testCase.verifySubstring(app.StatusLabel.Text, 'Cleaned');

            exploreButton = findobj(app.UIFigure, 'Type', 'uibutton', 'Text', 'Explore Data');
            press(testCase, exploreButton);
            testCase.verifyEqual(app.ResultsTabGroup.SelectedTab, app.ChartTab);
            testCase.verifyNotEmpty(findall(app.ChartGrid, 'Type', 'linegradientchart'));
            testCase.verifySubstring(app.ExploreSummaryLabel.Text, 'File Exchange trend');

            choose(testCase, app.PlotTypeDropDown, 'Relationship');
            testCase.verifyNotEmpty(findall(app.ChartGrid, 'Type', 'scatterfitchart'));
            testCase.verifySubstring(app.ExploreSummaryLabel.Text, 'ScatterFitChart screen');

            choose(testCase, app.PlotTypeDropDown, 'Prediction check');
            testCase.verifyGreaterThanOrEqual(numel(findobj(app.ExploreAxes, 'Type', 'Line')), 2);
        end
    end
end
