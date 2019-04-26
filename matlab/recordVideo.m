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

switch dataset
	case {'building', 'flip', 'garfield', 'stripes'}
		accumul_time = 300;
	otherwise
		accumul_time = 0.03;
end


for i = 1:length(events_with_lifetime)
	event = events_with_lifetime(i,:);
	t_expired(event(2)+1, event(1)+1) = event(4) + event(7);
	sae(event(2)+1, event(1)+1) = event(4);
	
	if event(end,4) > prev_ms
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
		prev_ms = prev_ms + accumul_time;
		
		frame = getframe(gcf);
        writeVideo(writerObj, frame);
	end
end

% close movie object
close(writerObj);