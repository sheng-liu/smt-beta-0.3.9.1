## createTrackll-methods
##' @name createTrackll
##' @aliases createTrackll
##' @title createTrackll
##' @rdname createTrackll-methods
##' @docType methods
##'
##' @description take in Diatrack (.txt or .mat), ImageJ Particle Tracker 
##' (.csv), SLIMfast (.txt), or u-track (.mat) input from a folder to output 
##' a list of track lists.

##' @usage 
##' createTrackll(folder, interact = FALSE, input = 1, ab.track = FALSE, 
##' cores = 1, frameRecord = TRUE)

##' @param interact Open interactive menu to choose the desired folder by 
##' selecting any file in it and select input type (script will process all 
##' files of that type in this folder).
##' @param folder Full path output file folder (ensure each folder has files 
##' of only one input type).
##' @param input Input file type (Diatrack .txt file = 1; Diatrack .mat 
##' session file = 2; ImageJ .csv file = 3; SLIMfast .txt file = 4; 
##' u-track .mat file = 5).
##' @param ab.track Use absolute coordinates for tracks.
##' @param cores Number of cores used for parallel computation. This can be 
##' the cores on a workstation, or on a cluster. Each core will be assigned to 
##' read one file when in parallel.
##' @param frameRecord Add a fourth column to the track list after the 
##' xyz-coordinates for the frame that coordinate point was found (especially 
##' helpful when linking frames). Highly recommended to leave on.
##' @return trackll
##' @details
##' 
##' (Note: When reading only Diatrack .mat session files (input = 2), 
##' intensities will be saved after the frame column)
##' 
##' It is highly advised that the frame record option be left on to preserve 
##' the most information, especially when linking frames and when using Utrack.
##' If the frame record option is turned on for reading Diatrack .txt files 
##' (input = 1), take note that the frame record is artificially created as 
##' consecutive frames after the given start frame.
##' Otherwise, all other data types naturally record the frames of every 
##' coordinate point.
##'
##' The pre-censoring of single-frame tracks is dependent on the tracking 
##' software. For highest fidelity track data, use Diatrack (.mat) session 
##' files.
##' If the initial creation of the trackll does not have a frame record, 
##' future exports and imports of the trackll will only preserve the start 
##' frames.
##'
##' If the cores are set to the maximum number of cores available on the 
##' system, the script may return a error after processing all the files. 
##' This error is due to the requirement of some systems to have one core 
##' open for system functions. 
##' This error will not affect the trackll output, but to avoid it, one can 
##' input one less than the maximum number of cores available.
##'
##' The naming scheme for the list of track list is as follows:
##' 
##' Track List: [full name of input file]
##' 
##' Track: [Last five characters of the file name].[Start frame].[Length].
##' [Track].[Index in overall list (will differ from Track # when merging)]
##' 
##' (Note: The last five characters of the file name, excluding the extension, 
##' cannot contain '.')

##' @examples
##' 
##' # Designate a folder and then create trackll from .csv data
##' folder=system.file('extdata','SWR1',package='sojourner')
##' trackll = createTrackll(folder=folder, input=3)
##' # Alternatively, use interact to open file 
##' # browser and select input data type
##' # trackll <- createTrackll(interact = TRUE)
##' 
##' @export createTrackll
############################################################################### 

### createTrackll ###

createTrackll = function(folder, interact = FALSE, input = 1, ab.track = FALSE, 
    cores = 1, frameRecord = TRUE) {
    
    # Interactive menu to select file in desired folder and input type
    if (interact == TRUE) {
        cat("Choose one file in the folder for processing... \n")
        folder = dirname(file.choose())
        input = 0
        if (input == 0) {
            cat("Folder selection:", folder, "\n")
            cat("Enter input file type and press ENTER: \n")
            cat("1. Diatrack .txt file \n")
            cat("2. Diatrack .mat session file: \n")
            cat("3. ImageJ/MOSAIC or exported save .csv file\n")
            cat("4. SLIMfast .txt file \n")
            cat("5. u-track .mat file \n")
            input <- readline()
        }
    }
    
    # Error if no input
    if (input > 5 || input < 1) {
        cat("Restart script with correct input.")
    }
    
    # Designate file types
    if (input == 1) {
        return(readDiatrack(folder, ab.track = ab.track, cores = cores, 
            frameRecord = frameRecord))
    } else if (input == 2) {
        return(readDiaSessions(folder, ab.track = ab.track, cores = cores, 
            frameRecord = frameRecord))
    } else if (input == 3) {
        return(readParticleTracker(folder, ab.track = ab.track, cores = cores, 
            frameRecord = frameRecord))
    } else if (input == 4) {
        return(readSlimFast(folder, ab.track = ab.track, cores = cores, 
            frameRecord = frameRecord))
    } else if (input == 5) {
        return(readUtrack(folder, ab.track = ab.track, cores = cores, 
            frameRecord = frameRecord))
    }
}
