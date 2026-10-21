function plan = buildfile
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

plan("clean") = CleanTask;
plan("check") = CodeIssuesTask;
plan("test") = TestTask;
plan("package") = PackageTask;

plan("package").Dependencies = "test";

plan.DefaultTasks = ["check" "test"];
end
