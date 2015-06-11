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
th comb-video-data.lua --video --data
```

```
video     (default ../Videos/)       Folder containing all the videos to be processed, '/' needed at the end
data      (default ../Data/)         Folder containing all the data files to be processed, '/' needed at the end
```

## Results 

Results of the extractor are saved in 

```bash
./frames
```

and 

```bash
./frame_info
```

with file names of separate frames.
