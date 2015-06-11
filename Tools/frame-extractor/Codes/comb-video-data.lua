-------------------------------------------------
-- VideoSensor data extractor -------------------
-- Data extracted from VideoSensors by koolrags--
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
op:option{'-v',        '--v',        action='store',        dest='video',        help='Video folder to process', default='../Videos/'}
op:option{'-d',        '--data',     action='store',        dest='data',         help='Data folder with all the information', default='../Data/'}
-- op:option{'-l',        '--loc',      action='store',        dest='location',     help=''}
opt, args = op:parse()

-- Function definitions ------------------------
function VideoRead(videoPath)
    status, height, width, length, fps = video_decoder.init(videoPath)
end

-- Make files for frames and information -------
function mkNewfolders()
    folName = {'frames', 'frame_info'}
    for i = 1, 2 do
        folOp = io.open('../' .. folName[i])
        if (folOp == nil) then
            print('mkdir ../' .. folName[i])
            os.execute('mkdir ../' .. folName[i])
        end
    end
end

-- Get file names -------------------------------
function getFilenames(folder)
    list = {}
    i = 0
    for name in io.popen('ls ' .. folder):lines() do
        i = i + 1
        list[i] = name:split('%.')[1]
    end
    return list
end

-- Retrieve inputs ------------------------------
mkNewfolders()
videoList = getFilenames(opt.video)
-- Process videos -------------------------------
io.write('--- Start processing data...\n')
for nv = 1, #videoList do
    name = videoList[nv]
    io.write('------ Current video name: ' .. name .. '.mp4\n')
    datafileID = io.open(opt.data .. name .. '.csv', 'r')
    titles = datafileID:read()
    VideoRead(opt.video .. name .. '.mp4')               -- Read video by libvideo_decoder
    local nb_frames = length                             -- Retrieve video length
    io.flush()
    for f = 0, nb_frames do                              -- For every frame
        io.flush()
        dst = torch.ByteTensor(3, height, width)
        video_decoder.frame_rgb(dst)                     -- Get frames
        image.save(string.format('../frames/%s-%04d.png', name, f), dst:float()/255.0)
    	writefileID = io.open(string.format('../frame_info/%s-%04d.txt', name, f), 'w')
        writefileID:write(titles .. '\n')
        writefileID:write(datafileID:read() .. '\n')
        writefileID.close()
        -- Progressbar
        n_sp = math.floor(100*f/nb_frames)
        io.write('\r[' .. string.rep('#', n_sp) .. string.rep('-', 100-n_sp) .. string.format('] (%d/%d)', f, nb_frames))
    end
    io.write('\n')
    video_decoder.exit()
    datafileID.close()
end
io.write('------ Videos all processed successfully.\n')
