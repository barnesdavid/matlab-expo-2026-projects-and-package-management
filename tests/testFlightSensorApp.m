classdef testFlightSensorApp < matlab.uitest.TestCase
    %testFlightSensorApp App-level workflow tests for FlightSensorApp.

    properties (Access = private)
        App
    end

    methods (TestClassSetup)
        function openDemoProject(~)
            projectFolder = fileparts(fileparts(mfilename("fullpath")));
            openProject(projectFolder, Prompt=false);
        end
    end

    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.App = FlightSensorApp;
            testCase.App.ShowAlerts = false;
            drawnow;
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

            press(testCase, app.ExploreDataButton);
            testCase.verifyEqual(app.ResultsTabGroup.SelectedTab, app.ChartTab);
            childClasses = arrayfun(@class, app.ChartGrid.Children, UniformOutput=false);
            testCase.verifyTrue(any(strcmp(childClasses, 'ScatterFitChart')));
            testCase.verifySubstring(app.ExploreSummaryLabel.Text, 'Altitude has r = 0.90');
        end
    end
end
