function [ file_paths ] = read_folder_contents_rec( basedir, extension, wildcard )
% function [ file_list, isdir, numfiles ] = READ_FOLDER_CONTENTS_REC( root_dir, extension, wildcard )
% Robert Cooper 17 - 06
% This function recursively extracts all filenames from a folder into a cell array.
%
% [ file_list, isdir, numfiles ] = READ_FOLDER_CONTENTS_REC( root_dir )
%       Returns an Nx1 cell array of character vectors (file_list);
%       each cell contains the filename of a file in the subtree of
%       directory specified specified (root_dir).
%       
%
% [ ... ] = READ_FOLDER_CONTENTS_REC( root_dir, extension )
%       Including an character vector with JUST the extension of the files of
%       interest will only return the above for files that match that
%       extension.
%
%       For example: READ_FOLDER_CONTENTS( 'C:\Windows', 'dll'); will
%       return a cell array of all dll files in the Windows subdirectory.
%
% [ ... ] = READ_FOLDER_CONTENTS_REC( root_dir, extension, wildcard )
%       Including an character vector with the extension and wildcard
%       of the files of interest will only return the above for files that
%       match that wildcard and extension.
%
%       For example: READ_FOLDER_CONTENTS( 'C:\Windows', 'dll', 'py'); will
%       return a cell array of all dll files in the Windows subdirectory that
%       contain the string 'py'.
%

file_paths={};

[file_list, isdir, numfiles] = read_folder_contents(basedir, extension, wildcard);

for i=1:numfiles   
    if isdir{i}
        file_paths = [file_paths; read_folder_contents_rec(fullfile(basedir,file_list{i}), extension, wildcard)];
    else
        file_paths = [file_paths; {fullfile(basedir,file_list{i})}];
    end    
end

end

