# VideoSensors frame extractor for Lua / Torch

The frame extractor is mainly used to extract the video and data (.csv) file frame by frame.

## How to run

```bash
cd Codes
th comb-video-data.lua
```

## Arguments

The frame extractor has the following arguments.

```bash
th comb-video-data.lua --video_data --loc
```

```
video     (default ../elab/)       Folder containing all the videos and datafiles to be processed, separated in different folders, and '/' needed at the end
data      (default ../)            Target folder to save the frame pictures and datafiles, '/' needed at the end
```

## Results 

Results of the extractor are saved in 

```bash
location/frames
```

and 

```bash
location/frames_info
```

with file names of separate frames. `location` is the target folder specified in the arguments as `--loc`.
