function make_combo_atlas(cortimg,subimg,cortxmlfile,subxmlfile,outputimage,outputlabels,roidir)
% from HarvardOxford directory, call it as:
% make_combo_atlas(,'HarvardOxfor
% d-sub-maxprob-thr25-2mm.nii',
if ~exist('cortimg'),
    cortimg='HarvardOxford-cort-maxprob-thr25-2mm.nii';
end
if ~exist('subimg'),
    subimg='HarvardOxford-sub-maxprob-thr25-2mm.nii';
end
if ~exist('cortxmlfile'),
    cortxmlfile='../HarvardOxford-Cortical.xml';
end
if ~exist('subxmlfile'),
    subxmlfile='../HarvardOxford-Subcortical.xml';
end
if ~exist('outputimage'),
    outputimage='HarvardOxford-combo-maxprob-thr25-2mm.nii';
end;
if ~exist('outputlabels'),
    outputlabels='HarvardOxford-combo-labels.txt';
end;

cort=load_nii(cortimg);
cort.img=int16(cort.img);
subcort=load_nii(subimg);
subcort.img=int16(subcort.img);

% first get rid of cortical and WM labels in subcort image
subcort_labels_to_replace=[2 3 4 41 42 43];
for x=subcort_labels_to_replace,
    subcort.img(find(subcort.img==x))=0;
end;

% fix labels for subcortical areas

ctr=97;
subcort_nums=[10:13 17:18 26 49:54 58 16];  % 16 is brainstem, put it at the end

for x=subcort_nums,
    if x>0,
        subcort.img(find(subcort.img==x))=ctr;
        ctr=ctr+1;
    end;
end;

% add separate left and right hemisphere cortical labels
cort.img(46:91,:,:)=cort.img(46:91,:,:)+100;
cort.img(find(cort.img==100))=0;
cort.img(cort.img>100)=cort.img(cort.img>100)-52;

new=cort;
new.img=cort.img + subcort.img;
new.hdr.dime.datatype=4;
new.hdr.dime.bitpix=16;
new.hdr.hist.aux_file='';
new.hdr.hist.descrip='make_combo_atlas';

save_nii(new,outputimage);

% make structure lists

sub_t=parseXML(subxmlfile);
cor_t=parseXML(cortxmlfile);

for i=1:length(cor_t.Children(4).Children)
    cor_idx(i)=-1;
    if ~isempty(cor_t.Children(4).Children(i).Attributes),
        cor_idx(i)=str2num(cor_t.Children(4).Children(i).Attributes(1).Value);
        cor_label(i)={cor_t.Children(4).Children(i).Children.Data};
    end;
end
for i=1:length(sub_t.Children(4).Children)
    sub_idx(i)=-1;
    if ~isempty(sub_t.Children(4).Children(i).Attributes),
        sub_idx(i)=str2num(sub_t.Children(4).Children(i).Attributes(1).Value);
        sub_label(i)={sub_t.Children(4).Children(i).Children.Data};
    end;
end



labels=cell(1,max(unique(new.img)));
cor_labels=cor_label(find(cor_idx>-1));
sub_labels=sub_label(find(sub_idx>-1));

for l=1:48,
    labels(l)={['L ' cor_labels{l}]};
end;
for l=49:96,
    labels(l)={['R ' cor_labels{l-48}]};
end
labels(97:103)=sub_labels([4:7 9:11]);
labels(104:110)=sub_labels(15:21);
labels(111)=sub_labels(8);

fid=fopen(outputlabels,'w');
for x=1:111,
    fprintf(fid,'%d\t%s\n',x,labels{x});
end;
fclose(fid);
labels=labels(1:111);

save(strrep(outputlabels,'.txt','.mat'),'labels');

if ~exist('roidir')
    roidir=outputimage(1:(strfind(outputimage,'.')-1))
    mkdir(roidir);
end;
for x=1:111,
    cmd=sprintf('fslmaths %s -thr %0.1f -uthr %0.1f -bin %s/roi%03d',...
        outputimage,x-0.5,x+0.5,roidir,x);
    fprintf('%s\n',cmd);
    unix(cmd);
end;
% helper functions to deal with XML files

function theStruct = parseXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.
% from the MATLAB help page for the readxml function
try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.');
end


% ----- Subfunction PARSECHILDNODES -----
function children = parseChildNodes(theNode)
% Recurse over node children.
children = [];
if theNode.hasChildNodes
   childNodes = theNode.getChildNodes;
   numChildNodes = childNodes.getLength;
   allocCell = cell(1, numChildNodes);

   children = struct(             ...
      'Name', allocCell, 'Attributes', allocCell,    ...
      'Data', allocCell, 'Children', allocCell);

    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        children(count) = makeStructFromNode(theChild);
    end
end

% ----- Subfunction MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
   'Name', char(theNode.getNodeName),       ...
   'Attributes', parseAttributes(theNode),  ...
   'Data', '',                              ...
   'Children', parseChildNodes(theNode));

if any(strcmp(methods(theNode), 'getData'))
   nodeStruct.Data = char(theNode.getData); 
else
   nodeStruct.Data = '';
end

% ----- Subfunction PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

attributes = [];
if theNode.hasAttributes
   theAttributes = theNode.getAttributes;
   numAttributes = theAttributes.getLength;
   allocCell = cell(1, numAttributes);
   attributes = struct('Name', allocCell, 'Value', ...
                       allocCell);

   for count = 1:numAttributes
      attrib = theAttributes.item(count-1);
      attributes(count).Name = char(attrib.getName);
      attributes(count).Value = char(attrib.getValue);
   end
end

