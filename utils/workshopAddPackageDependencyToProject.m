function workshopAddPackageDependencyToProject
%WORKSHOPADDPACKAGEDEPENDENCYTOPROJECT Activate the Chart_Examples template.
projectFileLines = readlines("matlab.toml");
if any(projectFileLines == "[dependencies]")
    return
end

% Prefer the starter template so users can compare the TOML change directly.
commentedDependencyTable = "#[dependencies]";
commentedDependency = "#Chart_Examples = {version = "">=2.3.2"", id = ""d47c73c1-4864-4beb-93d4-9642d80fcb1b""}";
if any(projectFileLines == commentedDependencyTable) && any(projectFileLines == commentedDependency)
    projectFileLines(projectFileLines == commentedDependencyTable) = "[dependencies]";
    projectFileLines(projectFileLines == commentedDependency) = extractAfter(commentedDependency, 1);
    writelines(projectFileLines, "matlab.toml");
    return
end

% Keep exactly one blank line between existing TOML and an appended section.
while ~isempty(projectFileLines) && projectFileLines(end) == ""
    projectFileLines(end) = [];
end

newLines = [
    ""
    "[dependencies]"
    "Chart_Examples = {version = "">=2.3.2"", id = ""d47c73c1-4864-4beb-93d4-9642d80fcb1b""}"
    ];
writelines([projectFileLines; newLines], "matlab.toml");
end
