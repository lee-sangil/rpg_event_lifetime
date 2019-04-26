plot_initialized = false;
prev_ms = 0;

sae = zeros(imSize);
t_expired = zeros(imSize);

fmtList = VideoReader.getFileFormats();
if any(ismember({fmtList.Extension}, 'mp4'))
    writerObj = VideoWriter([dataset, '.mp4'],'MPEG-4');
else
    writerObj = VideoWriter([dataset, '.avi']);
end
writerObj.FrameRate = 30; % How many frames per second.
open(writerObj);

fid = fopen('similarity.txt','w');
fprintf(fid, '# CDM similarity [0-100]\r\n');
fprintf(fid, '# Lifetime \r\n');
fprintf(fid, ['# created ' datestr(now,'ddd mmm dd HH:MM:SS') ' KST ' datestr(now, 'yyyy') '\r\n']);

switch dataset
	case {'building', 'flip', 'garfield', 'stripes'}
		accumul_time = 300;
	otherwise
		accumul_time = 0.03;
end

imStep = 1;
for i = 1:length(events_with_lifetime)
	event = events_with_lifetime(i,:);
	t_expired(event(2)+1, event(1)+1) = event(4) + event(7);
	sae(event(2)+1, event(1)+1) = event(4);
	
	if event(end,4) > image_timestamp(imStep)
		if ~plot_initialized
			subplot(121);
			f1 = imagesc(t_expired >= event(end,4));colormap(gca,gray);
			caxis([0 1]);
			set(gca, 'XTick',[], 'YTick',[], 'ZTick',[]);
			set(gcf,'Position',[100 100 960 320]);
			set(gca, 'Position', [0.05, 0.02, 0.45, 0.95]);
			
			subplot(122);
			f2 = imagesc(sae >= event(end,1)-accumul_time);colormap(gca,gray);
			caxis([0 1]);
			set(gca, 'Position', [0.51, 0.02, 0.45, 0.95], 'XTick',[], 'YTick',[], 'ZTick',[] );
			
			plot_initialized = true;
		else
			set(f1, 'CData', t_expired >= event(end,4));
			set(f2, 'CData', sae >= event(end,4)-accumul_time);
			drawnow;
		end
		
		frame = getframe(gcf);
        writeVideo(writerObj, frame);
		
		image = imread(imagesName{imStep});
		edgeCanny = edge(image, 'Canny', 0.3);
		edgeEvent = t_expired >= event(end,4);
		
		fprintf(fid, '%.4f\r\n', measureCDM(edgeCanny, edgeEvent));
		
		imStep = imStep + 1;
		
		if imStep > length(imagesName)
			break;
		end
	end
end

% close movie object
close(writerObj);
fclose(fid);