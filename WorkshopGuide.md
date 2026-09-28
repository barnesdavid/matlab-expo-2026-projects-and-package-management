# MATLAB Projects and Package Management

This 90\-minute workshop uses an air speed virtual sensor app to introduce MATLAB Projects, the MATLAB Package Manager, project dependencies, app testing, and toolbox packaging in MATLAB R2026b.

# What You Will Do
- Open a MATLAB Project and use its configured paths
- Run an app with an optional File Exchange capability missing
- Install and inspect a package with the MATLAB Package Manager
- Declare the package in `matlab.toml` so the project manages it
- Run app tests, capture the app, and build a toolbox

# Before You Start

Copy the clone URL using the button in GitHub.

<insert image of the button to clone the workshop>

Use MATLAB R2026b in MATLAB Online or on your desktop installation and clone the workshop repository with Home > New > Git Clone.

<insert image of how to clone>

# Open the Project

In the Files Panel, double\-click `matlab.toml`.

<insert picture of the files and highlight the `matlab.toml`>

Alternatively you can open the project using:

```matlab
openProject(pwd);
```

MATLAB opens the project, adding the `app`, `src`, `data`, and `examples` folders to the path.

<insert picture of the folders being on the path>

Now that the paths have been set up, we can now use scripts, functions, apps, and other MATLAB and Simulink files. Today we will be focusing on the app `FlightSensorApp`, and we can see where this is using the `which` function:

```matlab
which FlightSensorApp
```

```matlabTextOutput
C:\Codex\air-speed-virtual-sensor-app\app\FlightSensorApp.m  % FlightSensorApp constructor
```

```matlab
which FlightData.xlsx
```

```matlabTextOutput
C:\Codex\air-speed-virtual-sensor-app\data\FlightData.xlsx
```

The project is the reproducible context for this app. Its path configuration means the app can call helpers in `src` and load data from `data` without each user managing `addpath` calls.

# Run the Starter App

Now let's use the **Open flight sensor app** shortcut in the Project tab, or run the following:

```matlab
FlightSensorApp
```

<insert a picture of the app>

This app loads in data, cleans the data, and fits a machine learning model to be a virtual sensor using helper functions in the folder `src`.

Select **Explore Data**. The app opens the Explore tab, but this panel requires a package dependency to work. Let's close the app and check what packages are available and using the `mpmlist` command.

```matlab
mpmlist
```

As you can see, the only package that is available is this project `"Air Speed Virtual Sensor"` which is noted as version `"1.0.0-dev"` to indicate that the package is under development.

Now we can close the project from the Project tab before installing the package manually. You can do this using the toolstrip or via the MATLAB Project APIs:

<insert picture of the button>

```matlab
proj = currentProject;
proj.close;
```

Note as well that when we close the project, the project folders are removed from the path, returning us to where we previously started.

<insert picture of the folders not added to the path>

# Install the Package Dependency Manually

In R2026b you can install packages using the Add\-Ons side panel or using the MPM commands. Let's start with installing the package from the Add\-Ons Side Panel, which has been available since R2026b.

<insert picture of the panel>

You can search for the package "Chart Examples" and install the package using a point\-and\-click interaction.

Starting in R2026b, MPM now supports installing from File Exchange. Package managers install packages from package repositories, and MPM supports several package repository types. We can see which package repositories are configured using the following:

```matlab
mpmListRepositories
```

By default in R2026b, File Exchange is pre\-configured as a package repository. For more information about adding and removing package repositories, please see the following:

- mpmAddRepository
- mpmRemoveRepository

Since we have confirmed that MPM is configured to install from File Exchange, you can run this command in the Command Window to install Chart Examples.

```matlab
mpminstall chart_examples
```

If you want to determine the command to install a particular package from File Exchange, you can see the command in the submission for File Exchange:

[https://www.mathworks.com/matlabcentral/fileexchange/65857\-chart\-examples](https://www.mathworks.com/matlabcentral/fileexchange/65857-chart-examples)

<insert picture of the install command from File Exchange>

The File Exchange page also provides information about the package author, files, versions, and more.

Now we can list the packages that are installed as well as additional information by assigning an output to mpmlist:

```matlab
out = mpmlist
```

Now that we have installed the package, let's reopen the project, and run `FlightSensorApp`. Select **Explore Data**, then explore the Trend and Relationship plot types.

```matlab
openProject(pwd);
FlightSensorApp
```

The same app now works with both the project folders being added to the path and the package dependency being installed. But how can we help others who are using the MATLAB Project?

# Declare the Package Dependency

While we manually installed the package previously, but it does not ensure that other users of an app will have Chart Examples installed.  to another user. Starting in R2026b MATLAB Projects can declare its package requirements in `matlab.toml`. You can add the package as a dependency by clicking on the "Dependencies" in the Project Toolstrip:

<insert picture of the Dependencies button>

This project does not have any dependencies declared, but you can add a new dependency with the new Dependency button to add a new Package Dependency

<insert picture of the dropdown for the types of dependencies>

Search for "chart" or "chart\_examples" and select the package dependency.

<insert picture of the dependency being added>

NOTE: MATLAB Projects support both a package dependency and a reference project dependency. You will use reference project dependencies if you do need to co\-develop two code bases together. To create a reference project dependency, you would clone the git repository to another folder or add a git Submodule.

Now we can close the project and look at the updates to the `matlab.toml` file

```matlab
proj = currentProject;
proj.close;
```

We can open the diff report by right clicking on the `matlab.toml` file:

<insert image of the menu for matlab.toml>

We can see that the package is now declared as dependency in the new `[dependencies]` table:

<insert image from the diff report>

# Use Project to Control the Environment

Previously we had manually installed Chart Examples. Let's return our environment to the state of an end user of the project by uninstalling Chart Examples:

```matlab
mpmuninstall chart_examples
```

NOTE: If you have many packages installed and you want to remove them all at once, you can uninstall them all using 

```
mpmuninstall(mpmlist)
```

And now we can check that we are back to a clean working state using `mpmlist`

```matlab
mpmlist
```

Reopen the project by double clicking on `matlab.toml`. MATLAB Projects will now add the declared folders to the path and install the missing package dependencies.

```matlab
openProject(pwd)
```

Verify that the package is installed again using `mpmlist`

```matlab
mpmlist
```

Run `FlightSensorApp` once more and select **Explore Data**. Confirm that the Trend and Relationship charts are available without running `mpminstall` yourself.

# Run the Tests

The project includes an app workflow test. It verifies the primary data, cleanup, and File Exchange Explore chart workflow. The test also captures the initial app window with `exportapp` and writes `results/FlightSensorApp.png`. You can run the tests using the MATLAB Unit Testing APIs or through Build Tool, which can be accessed from the MATLAB Project Toolstrip or simply calling the build tool APIs:

<insert screenshot of the build tool dropdown>

```matlab
results = runtests("tests") % MATLAB Unit Test APIs
buildtool test % MATLAB Build Tool API
```

NOTE: For more information about testing, build automation, and continuous integration (CI), check out the following workshops:

- MATLAB Expo Workshop on Testing:
- MATLAB Expo Workshop on Build Automation and CI:

Inspect the generated screenshot after the test run. The image is a useful record of the tested UI state and is excluded from source control.

```matlab
open(fullfile(projectRoot, "results", "FlightSensorApp.png"))
```

All tests should be passing! Now we can proceed with building a package to share the app, functions, and data with others.

# Build the Package Interactively

Once you are done developing your code, we can now easily share it as a package for others to consume and depend on. To get started, we can open the new "Build Package" tool in the MATLAB Projects Toolstrip:

<insert image of the build package task>

Here configure the package by first selecting a package folder.

<insert image of the selected folder>.

Additionally, configure that package information:

- Display name \- easily readable name; spaces are allowed
- Version \- Semantic Version enforced; major.minor.patch syntax
- Package Name \- must be a valid MATLAB identifier; what is called with mpminstall packagename
- Author name
- Email
- Company
- Summary

<insert screenshot with this filled out>

Packages can also depend on other packages, so in this case our `AirSpeedVirtualSensor` package will depend on `chart_examples`

<insert screenshot of the package requirements section>

Finally for this workshop, we will also check the Output settings, setting the Output File Name to be configured to match the "Package Name" and "Version"

<insert image of the Output Settings section of the UI>

Now that everything is set, simply click "Build Package" to generate the MLTBX!

<image of the build package button>

You can now close the Tasks panel

<image of the Tasks menu to close it>

# Build the Package Automatically

While we previously build the package interactively, you can also build the package automatically through MATLAB build tool.

All of the information we previously entered in to the Build Package Task is saved in the `[[package]]` section of `matlab.toml` file. We can view this by opening the `matlab.toml` as text or using edit

```matlab
edit matlab.toml
```

In R2026b, MATLAB build tool has a new `PackageTask` that reads configuration in the matlab.toml to create the `.mltbx` file automatically. You can see this already added to the `buildfile.m` using the following:

```matlab
open buildfile
```

With everything already configured, you can simply call the task to generate the `.mltbx` file using the build tool API or the dropdown in the MATLAB Toolstrip

```matlab
buildtool package
```

<screenshot of the build tool ui>

Confirm that the package was built by verifying that `release/AirSpeedVirtualSensor_1_0_0.mltbx` exists. 

<image of the mltbx existing>

Now that we have built the package, we are ready to publish this to a package repository.

# Summary

A MATLAB Project ensure that your have a consistent environment for your codebase by managing the paths, package dependencies, tests, and other metadata in a single `matlab.toml` file. Manual package installation is a useful first step, while `matlab.toml` turns that setup into a project requirement that MATLAB restores on project open.