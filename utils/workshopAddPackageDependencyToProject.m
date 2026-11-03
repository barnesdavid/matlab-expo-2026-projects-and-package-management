function workshopAddPackageDependencyToProject
%WORKSHOPADDPACKAGEDEPENDENCYTOPROJECT Activate the Chart_Examples template.
projectFileLines = readlines("matlab.toml");
dependencyTable = "[dependencies]";
dependencyLine = "Chart_Examples = {version = "">=2.3.2"", id = ""d47c73c1-4864-4beb-93d4-9642d80fcb1b""}";
commentedDependency = "#" + dependencyLine;

if any(projectFileLines == dependencyLine)
    return
end

commentedDependencyIndex = find(projectFileLines == commentedDependency, 1);
dependencyTableIndex = find(projectFileLines == dependencyTable, 1);
if ~isempty(commentedDependencyIndex) && ~isempty(dependencyTableIndex)
    projectFileLines(commentedDependencyIndex) = dependencyLine;
    writelines(projectFileLines, "matlab.toml");
    return
end

if ~isempty(commentedDependencyIndex)
    projectFileLines = [
        projectFileLines(1:commentedDependencyIndex - 1)
        dependencyTable
        dependencyLine
        projectFileLines(commentedDependencyIndex + 1:end)
        ];
    writelines(projectFileLines, "matlab.toml");
    return
end

if ~isempty(dependencyTableIndex)
    projectFileLines = [
        projectFileLines(1:dependencyTableIndex)
        dependencyLine
        projectFileLines(dependencyTableIndex + 1:end)
        ];
    writelines(projectFileLines, "matlab.toml");
    return
end

% Recreate the table if it was removed during the workshop.
while ~isempty(projectFileLines) && projectFileLines(end) == ""
    projectFileLines(end) = [];
end

newLines = [
    ""
    dependencyTable
    dependencyLine
    ];
writelines([projectFileLines; newLines], "matlab.toml");
end
