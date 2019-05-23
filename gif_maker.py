import imageio
import os
import re

cwd = os.getcwd()
 # on Mac: right click on a folder, hold down option, and click "copy as pathname"

image_folder = os.fsencode(cwd)

filenames = []

for file in os.listdir(image_folder):
    filename = os.fsdecode(file)
    if filename.endswith( ('.jpeg', '.png', '.gif') ):
        filenames.append(filename)

filenames.sort(key=lambda var:[int(x) if x.isdigit() else x for x in re.findall(r'[^0-9]|[0-9]+', var)]) # this iteration technique has no built in order, so sort the frames

images = list(map(lambda filename: imageio.imread(filename), filenames))

imageio.mimsave(os.path.join('transcriptome.gif'), images, duration = 0.30) # modify duration
