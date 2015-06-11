-------------------------------------------------
-- VideoSensor data extractor -------------------
-- Data extracted from VideoSensors by Raaghav Karthik (koolrags)--
-------------------------------------------------
-- Jarvis Du ------------------------------------
-- June 9, 2015 ---------------------------------
-------------------------------------------------

-- Requires -------------------------------------
require 'sys'
require 'image'
video_decoder = require('libvideo_decoder')

-- Parse args -----------------------------------
op = xlua.OptionParser('%prog [options]')
op:option{'-vd',        '--video_data',        action='store',        dest='vd',            help='Video & data folder to process',            default='../elab/'}
op:option{'-l',         '--loc',               action='store',        dest='location',      help='Destination folder',                        default='../'}
opt, args = op:parse()

-- Function definitions ------------------------
function VideoRead(videoPath)
    status, height, width, length, fps = video_decoder.init(videoPath)
end

-- Make files for frames and information -------
function mkNewfolders(folder)
    folName = {'frames', 'frames_info'}
    for i = 1, 2 do
        folOp = io.open(folder .. folName[i])
        if (folOp == nil) then
            print('mkdir ' .. folder .. folName[i])
            os.execute('mkdir ' .. folder .. folName[i])
        end
    end
end

-- Get file names -------------------------------
function getFilenames(folder)
    list = {}
    i = 0
    for name in io.popen('ls ' .. folder):lines() do
        i = i + 1
        list[i] = name
    end
    return list
end

-- Retrieve inputs ------------------------------
mkNewfolders(opt.location)
videoList = getFilenames(opt.vd)

-- Process videos -------------------------------
io.write('--- Start processing data...\n')
for nv = 1, #videoList do
    name = videoList[nv]
    io.write('------ Current video folder: ' .. name .. '\n')
    -- Make folders within data folders
    os.execute('mkdir ' .. opt.location .. 'frames/' .. name)
    os.execute('mkdir ' .. opt.location .. 'frames_info/' .. name)
    datafile = io.open(opt.vd .. name .. '/' .. name .. '.csv'):lines()
    titles = datafile(1)
    VideoRead(opt.vd .. name .. '/' .. name .. '.mp4')   -- Read video by libvideo_decoder
    local nb_frames = length                             -- Retrieve video length
    for f = 0, nb_frames do                              -- For every frame
        io.flush()
        dst = torch.ByteTensor(3, height, width)
        video_decoder.frame_rgb(dst)                     -- Get frames
        image.save(string.format(opt.location .. 'frames/' .. name .. '/%s-%04d.png', name, f), dst:float()/255.0)
    	writefileID = io.open(string.format(opt.location .. 'frames_info/' .. name .. '/%s-%04d.txt', name, f), 'w')
        writefileID:write(titles .. '\n')
        writefileID:write(datafile(f+2) .. '\n')
        writefileID.close()
        -- Progressbar
        n_sp = math.floor(100*f/nb_frames)
        io.write('\r[' .. string.rep('#', n_sp) .. string.rep('-', 100-n_sp) .. string.format('] (%d/%d)', f, nb_frames))
    end
    io.write('\n')
    video_decoder.exit()
end
io.write('------ Videos all processed successfully.\n')
