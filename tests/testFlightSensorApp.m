classdef testFlightSensorApp < matlab.unittest.TestCase
    %testFlightSensorApp App-level workflow tests for FlightSensorApp.

    properties (Access = private)
        App
        ScreenshotFile string
    end

    methods (TestClassSetup)
        function configureScreenshotArtifact(testCase)
            projectRoot = fileparts(fileparts(mfilename("fullpath")));
            resultsFolder = fullfile(projectRoot, "results");
            if ~isfolder(resultsFolder)
                mkdir(resultsFolder);
            end
            testCase.ScreenshotFile = fullfile(resultsFolder, "FlightSensorApp.png");
        end
    end

    methods (TestMethodSetup)
        function launchApp(testCase)
            testCase.App = FlightSensorApp;
            testCase.App.ShowAlerts = false;
            drawnow
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
        function testCaptureAppScreenshot(testCase)
            drawnow
            exportapp(testCase.App.UIFigure, testCase.ScreenshotFile);
            testCase.verifyTrue(isfile(testCase.ScreenshotFile));
        end

        function testLoadPlotAndCleanWorkflow(testCase)
            app = testCase.App;

            packageInfo = mpmlist("chart_examples");
            testCase.assertTrue(~isempty(packageInfo) && packageInfo.Installed, ...
                "Chart Examples is required for this test. Run ""mpminstall chart_examples"" and reopen the project.");

            testCase.verifyEqual(app.ResultsTabGroup.SelectedTab, app.DataTab);
            testCase.verifyGreaterThan(height(app.DataTable.Data), 0);
            testCase.verifySubstring(app.StatusLabel.Text, 'Loaded 47312 rows');

            app.PlotDataButtonPushed([]);
            testCase.verifyEqual(app.ResultsTabGroup.SelectedTab, app.PlotTab);
            testCase.verifyGreaterThanOrEqual(numel(findobj(app.MainAxes, 'Type', 'Line')), 2);

            app.CleanDataButtonPushed([]);
            testCase.verifySubstring(app.StatusLabel.Text, 'Cleaned');

            app.ExploreDataButtonPushed([]);
            testCase.verifyEqual(app.ResultsTabGroup.SelectedTab, app.ChartTab);
            testCase.verifyNotEmpty(findall(app.UIFigure, 'Type', 'linegradientchart'));
            labels = findall(app.UIFigure, 'Type', 'uilabel');
            labelText = string({labels.Text});
            testCase.verifyTrue(any(contains(labelText, "File Exchange trend")));
        end
    end
end
