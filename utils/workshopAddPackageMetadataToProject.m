function workshopAddPackageMetadataToProject
projectFileLines = readlines("matlab.toml");
if any(projectFileLines == "[[package]]")
    return
end

while ~isempty(projectFileLines) && projectFileLines(end) == ""
    projectFileLines(end) = [];
end

newLines = [
    ""
    "[[package]]"
    "configuration-name = ""Package1"""
    "output-file-name = ""Air Speed Virtual Sensor.mltbx"""
    "output-folder = ""Package1/release"""
    "name = ""AirSpeedVirtualSensor"""
    "supported-platforms = ["
    "    ""windows"","
    "    ""linux"","
    "    ""macos"","
    "]"
    "display-name = ""Air Speed Virtual Sensor"""
    "version = ""1.0.0"""
    "id = ""f77c08eb-c68c-4478-9626-52ded59a6995"""
    "use-license-bsd = false"
    "package-root = ""src"""
    "summary = ""Explore NASA aircraft flight data and build a virtual airspeed sensor"""
    "provider.name = ""David Barnes"""
    "description = ""This MATLAB package provides sample flight data and an app to show how to clean flight data and build a virtual airspeed sensor from other available sensor signals."""
    "product-dependencies = ["
    "    ""MATLAB"","
    "    ""Statistics and Machine Learning Toolbox"","
    "]"
    ];
writelines([projectFileLines; newLines], "matlab.toml");
end
