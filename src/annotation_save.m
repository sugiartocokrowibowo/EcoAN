% Annotation.  An annotation creation tool for images.
% Copyright (C) 2010 Joel Granados <joel.granados@gmail.com>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


function annotation_save(handles, annotation)

    % WE SAVE ANNOTATION LOCALY
    VERSION=1.0;
    ann_file_name = char(strcat(annotation.file_name, '.ann'));

    [fd,syserrmsg]=fopen(ann_file_name,'wt');
    if (fd==-1),
        msgboxText{1} =  strcat('Error saving to file: ', ann_file_name);
        msgbox(msgboxText,'Please try to save again.');
        return;
    end;

    [p,f,e] = fileparts(char(annotation.file_name));
    file_name = strcat(f,e);

    fprintf(fd,'# PHENOLOGY ITU Annotation Version %0.2f\n',VERSION);
    fprintf(fd,'\n');
    fprintf(fd,'Image filename : "%s"\n',char(file_name));
    fprintf(fd,'\n');
    fprintf(fd,'# Top left pixel co-ordinates : (1, 1)\n');
    fprintf(fd,'\n');
    fprintf(fd,'Review %s %s', char(annotation.review.date),...
        char(annotation.review.reviewer));

    % The last region is always empty.
    size_regions = size(annotation.regions, 2);
    for i=1:size_regions,
        % We only save the active regions.
        if annotation.regions(i).active == 1
            bbox = round(getPosition(annotation.regions(i).roi));
            bbox = [bbox(1), bbox(2), bbox(1)+bbox(3), bbox(2)+bbox(4)];
            lbl = char(get(annotation.regions(i).label, 'string'));
            fprintf(fd,'\n# Details for object %d ("%s")\n',i,lbl);
            fprintf(fd,'Bounding box for object %d "%s" ', i, lbl);
            fprintf(fd, '(Xmin, Ymin) - (Xmax, Ymax) : ');
            fprintf(fd, '(%d, %d) - (%d, %d)\n',bbox);

        end
    end;

    fclose(fd);
end
