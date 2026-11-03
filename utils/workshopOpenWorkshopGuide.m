function workshopOpenWorkshopGuide
%WORKSHOPOPENWORKSHOPGUIDE Open the workshop guide in the Live Editor.
if batchStartupOptionUsed()
    return
end

project = currentProject;
if ~isempty(project)
    edit("WorkshopGuide.m")
end
end
