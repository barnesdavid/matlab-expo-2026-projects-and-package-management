function workshopRestoreOriginalProject
%WORKSHOPRESTOREORIGINALPROJECT Restore the workshop starter project file.
projectFileLines = readlines("matlab.toml");
newLines = [
    "name = ""Air Speed Virtual Sensor"""
    ""
    "[folders]"
    "path = [""src/app"", ""src"", ""src/data"", ""src/examples"", ""utils""]"
    "test = [""tests""]"
    ""
    "[project]"
    "summary = ""MATLAB Expo workshop for MATLAB Projects and package management in R2026b."""
    "shortcuts = {"
    "WorkshopGuide = {path = ""WorkshopGuide.m""},"
    "FlightSensorApp = {path = ""src/app/FlightSensorApp.m""}}"
    ""
    "#[dependencies]"
    "#Chart_Examples = {version = "">=2.3.2"", id = ""d47c73c1-4864-4beb-93d4-9642d80fcb1b""}"
    ];
if isequal(projectFileLines, newLines)
    return
end

writelines(newLines, "matlab.toml");
end
