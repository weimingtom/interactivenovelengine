<Project Configuration>
- two symlinks to $PROJECT_ROOT/Resources and $PROJECT_ROOT/BaseScripts
need to be present in compiled binary directory

for example, for a binary directory in $PROJECT_ROOT/bin,

mklink /D BaseScripts ..\BaseScripts
mklink /D Resources ..\Resources