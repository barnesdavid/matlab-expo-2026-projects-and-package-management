%[text] # MATLAB Projects and Package Management
%[text] This 90-minute workshop uses an air speed virtual sensor app to introduce MATLAB Projects, the MATLAB Package Manager, project dependencies, app testing, and toolbox packaging in MATLAB R2026b.
%[text] ## What You Will Do
%[text] - Open a MATLAB Project and use its configured paths
%[text] - Run an app with an optional File Exchange capability missing
%[text] - Install and inspect a package with the MATLAB Package Manager
%[text] - Declare the package in `matlab.toml` so the project manages it
%[text] - Run app tests, capture the app, and build a toolbox \
%[text] ## Before You Start
%[text] Copy the clone URL using the button in GitHub.
%[text] \<insert image of the button to clone the workshop\>
%[text] Use MATLAB R2026b in MATLAB Online or on your desktop installation and clone the workshop repository with Home \> New \> Git Clone.
%[text] \<insert image of how to clone\>
%%
%[text] ## Open the Project
%[text] In the Files Panel, double-click `matlab.toml`.
%[text] \<insert picture of the files and highlight the `matlab.toml`\>
%[text] Alternatively you can open the project using:
openProject(pwd);
%[text] MATLAB opens the project, adding the `src`, `src/app`, `src/data`, and `src/examples` folders to the path.
%[text] \<insert picture of the folders being on the path\>
%[text] Now that the paths have been set up, we can now use scripts, functions, apps, and other MATLAB and Simulink files. Today we will be focusing on the app `FlightSensorApp`, and we can see where this is using the `which` function:
which FlightSensorApp %[output:34c4c5bf]
which FlightData.xlsx %[output:71dab439]
%[text] The project is the reproducible context for this app. Its path configuration means the app can call helpers in `src` and load data from `data` without each user managing `addpath` calls.
%%
%[text] ## Run the Starter App
%[text] Now let's use the **Open flight sensor app** shortcut in the Project tab, or run the following:
FlightSensorApp
%[text] \<insert a picture of the app\>
%[text] This app loads in data, cleans the data, and fits a machine learning model to be a virtual sensor using helper functions in the folder `src`.
%[text] Select **Explore Data**. The app opens the Explore tab, but this panel requires a package dependency to work. Let's close the app and check what packages are available and using the `mpmlist` command.
mpmlist
%[text] As you can see, the only package that is available is this project `"Air Speed Virtual Sensor"` which is noted as version `"0.1.0-dev"` to indicate that the package is under development.
%[text] Now we can close the project from the Project tab before installing the package manually. You can do this using the toolstrip or via the MATLAB Project APIs:
%[text] \<insert picture of the button\>
proj = currentProject;
proj.close;
%[text] Note as well that when we close the project, the project folders are removed from the path, returning us to where we previously started.
%[text] \<insert picture of the folders not added to the path\>
%%
%[text] ## Install the Package Dependency Manually
%[text] In R2026b you can install packages using the Add-Ons side panel or using the MPM commands. Let's start with installing the package from the Add-Ons Side Panel, which has been available since R2026b.
%[text] \<insert picture of the panel\>
%[text] You can search for the package "Chart Examples" and install the package using a point-and-click interaction.
%[text] Starting in R2026b, MPM now supports installing from File Exchange. Package managers install packages from package repositories, and MPM supports several package repository types. We can see which package repositories are configured using the following:
mpmListRepositories
%[text] By default in R2026b, File Exchange is pre-configured as a package repository. For more information about adding and removing package repositories, please see the following:
%[text] - mpmAddRepository
%[text] - mpmRemoveRepository \
%[text] Since we have confirmed that MPM is configured to install from File Exchange, you can run this command in the Command Window to install Chart Examples.
mpminstall chart_examples
%[text] If you want to determine the command to install a particular package from File Exchange, you can see the command in the submission for File Exchange:
%[text] [https://www.mathworks.com/matlabcentral/fileexchange/65857-chart-examples](https://www.mathworks.com/matlabcentral/fileexchange/65857-chart-examples)
%[text] \<insert picture of the install command from File Exchange\>
%[text] The File Exchange page also provides information about the package author, files, versions, and more.
%[text] Now we can list the packages that are installed as well as additional information by assigning an output to mpmlist:
out = mpmlist
%[text] Now that we have installed the package, let's reopen the project, and run `FlightSensorApp`. Select **Explore Data**, then explore the Trend and Relationship plot types.
openProject(pwd);
FlightSensorApp
%[text] The same app now works with both the project folders being added to the path and the package dependency being installed. But how can we help others who are using the MATLAB Project?
%%
%[text] ## Declare the Package Dependency
%[text] While we manually installed the package previously, but it does not ensure that other users of an app will have Chart Examples installed.  to another user. Starting in R2026b MATLAB Projects can declare its package requirements in `matlab.toml`. You can add the package as a dependency by clicking on the "Dependencies" in the Project Toolstrip:
%[text] \<insert picture of the Dependencies button\>
%[text] This project does not have any dependencies declared, but you can add a new dependency with the new Dependency button to add a new Package Dependency
%[text] \<insert picture of the dropdown for the types of dependencies\>
%[text] Search for "chart" or "chart\_examples" and select the package dependency.
%[text] \<insert picture of the dependency being added\>
%[text] NOTE: MATLAB Projects support both a package dependency and a reference project dependency. You will use reference project dependencies if you do need to co-develop two code bases together. To create a reference project dependency, you would clone the git repository to another folder or add a git Submodule.
%[text] Now we can close the project and look at the updates to the `matlab.toml` file
proj = currentProject;
proj.close;
%[text] We can open the diff report by right clicking on the `matlab.toml` file:
%[text] \<insert image of the menu for matlab.toml\>
%[text] We can see that the package is now declared as dependency in the new `[dependencies]` table:
%[text] \<insert image from the diff report\>
%%
%[text] ## Use Project to Control the Environment
%[text] Previously we had manually installed Chart Examples. Let's return our environment to the state of an end user of the project by uninstalling Chart Examples:
mpmuninstall chart_examples
%[text] NOTE: If you have many packages installed and you want to remove them all at once, you can uninstall them all using 
%[text] ```matlabCodeExample
%[text] mpmuninstall(mpmlist)
%[text] ```
%[text] And now we can check that we are back to a clean working state using `mpmlist`
mpmlist
%[text] Reopen the project by double clicking on `matlab.toml`. MATLAB Projects will now add the declared folders to the path and install the missing package dependencies.
openProject(pwd)
%[text] Verify that the package is installed again using `mpmlist`
mpmlist
%[text] Run `FlightSensorApp` once more and select **Explore Data**. Confirm that the Trend and Relationship charts are available without running `mpminstall` yourself.
%%
%[text] ## Run the Tests
%[text] The project includes an app workflow test. It verifies the primary data, cleanup, and File Exchange Explore chart workflow. The test also captures the initial app window with `exportapp` and writes `results/FlightSensorApp.png`. You can run the tests using the MATLAB Unit Testing APIs or through Build Tool, which can be accessed from the MATLAB Project Toolstrip or simply calling the build tool APIs:
%[text] \<insert screenshot of the build tool dropdown\>
results = runtests("tests") % MATLAB Unit Test APIs
buildtool test % MATLAB Build Tool API
%[text] NOTE: For more information about testing, build automation, and continuous integration (CI), check out the following workshops:
%[text] - MATLAB Expo Workshop on Testing:
%[text] - MATLAB Expo Workshop on Build Automation and CI:  \
%[text] Inspect the generated screenshot after the test run. The image is a useful record of the tested UI state and is excluded from source control.
open(fullfile(currentProject().RootFolder, "results", "FlightSensorApp.png"))
%[text] All tests should be passing! Now we can proceed with building a package to share the app, functions, and data with others.
%%
%[text] ## Build the Package Interactively
%[text] Once you are done developing your code, we can now easily share it as a package for others to consume and depend on. To get started, we can open the new "Build Package" tool in the MATLAB Projects Toolstrip:
%[text] \<insert image of the build package task\>
%[text] Here configure the package by first selecting a package folder.
%[text] \<insert image of the selected folder\>.
%[text] Additionally, configure that package information:
%[text] - Display name - easily readable name; spaces are allowed
%[text] - Version - Semantic Version enforced; major.minor.patch syntax
%[text] - Package Name - must be a valid MATLAB identifier; what is called with mpminstall packagename
%[text] - Author name
%[text] - Email
%[text] - Company
%[text] - Summary \
%[text] \<insert screenshot with this filled out\>
%[text] Packages can also depend on other packages, so in this case our `AirSpeedVirtualSensor` package will depend on `chart_examples`
%[text] \<insert screenshot of the package requirements section\>
%[text] Finally for this workshop, we will also check the Output settings, setting the Output File Name to be configured to match the "Package Name" and "Version"
%[text] \<insert image of the Output Settings section of the UI\>
%[text] Now that everything is set, simply click "Build Package" to generate the MLTBX!
%[text] \<image of the build package button\>
%[text] You can now close the Tasks panel
%[text] \<image of the Tasks menu to close it\>
%%
%[text] ## Build the Package Automatically
%[text] While we previously build the package interactively, you can also build the package automatically through MATLAB build tool.
%[text] All of the information we previously entered in to the Build Package Task is saved in the `[[package]]` section of `matlab.toml` file. We can view this by opening the `matlab.toml` as text or using edit
edit matlab.toml
%[text] In R2026b, MATLAB build tool has a new `PackageTask` that reads configuration in the matlab.toml to create the `.mltbx` file automatically. You can see this already added to the `buildfile.m` using the following:
open buildfile
%[text] With everything already configured, you can simply call the task to generate the `.mltbx` file using the build tool API or the dropdown in the MATLAB Toolstrip
buildtool package
%[text] \<screenshot of the build tool ui\>
%[text] Confirm that the package was built by verifying that `release/AirSpeedVirtualSensor_1_0_0.mltbx` exists. 
%[text] \<image of the mltbx existing\>
%[text] Now that we have built the package, we are ready to publish this to a package repository.
%%
%[text] ## Summary
%[text] A MATLAB Project ensure that your have a consistent environment for your codebase by managing the paths, package dependencies, tests, and other metadata in a single `matlab.toml` file. Manual package installation is a useful first step, while `matlab.toml` turns that setup into a project requirement that MATLAB restores on project open.

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
%[output:34c4c5bf]
%   data: {"dataType":"text","outputData":{"text":"C:\\Codex\\air-speed-virtual-sensor-app\\app\\FlightSensorApp.m  % FlightSensorApp constructor\n","truncated":false}}
%---
%[output:71dab439]
%   data: {"dataType":"text","outputData":{"text":"C:\\Codex\\air-speed-virtual-sensor-app\\data\\FlightData.xlsx\n","truncated":false}}
%---
