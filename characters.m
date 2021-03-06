function[b] = characters(img)
    b = [];
    imb = platebin(img,3,7);
    
    [h,w] = size(img);
    altura = h;
    
    imb(:,:) = not (imb(:,:));
    imb = imclearborder(imb);
    
    %imshow(imb)
    %hold on
       
    r = regionprops(imb,'boundingbox');
    a = cat(1, r.BoundingBox);
    
    j = 1;
    for i = 1:size(a,1)
        if (a(i, 3)*1.2) < a(i, 4) && a(i, 4) > (0.3*altura) && a(i, 4) < (0.8*altura) && isCharacter(img,a(i,:))
            %{
            cp = imcrop(img,a(i,:));
            im = rgb2gray(cp);
            g = graythresh(im);
            cp = im2bw(im,g);
            [hh ww] = size(cp); 
            perc = sum(cp(:))/(ww*hh);
            %}
            cp = imcrop(imb,a(i,:));
            %cp = imopen(cp,strel('rectangle',[3 1]));
            [hh ww] = size(cp);
            perc = sum(cp(:))/(ww*hh);
            %(a(i, 3)*3) >= a(i, 4)
            
            if (ww/hh) < 0.3
                hal = cp(:,1:round(ww/2));
                har = cp(:,round(ww/2):end);
                [hr wr] = size(har);
                whr = (hr*wr);
                per = sum(har(:))/whr;
                pel = sum(hal(:))/whr;
                if (per < 0.90) && (pel < 0.40)
                    b(j, :) = [(a(i,1)-1) (a(i,2)-1) (a(i,3)+2) (a(i,4)+2)];
                    j = j + 1;     
                end
                
            elseif (perc <= 0.80 && perc >= 0.25)
                b(j, :) = [(a(i,1)-1) (a(i,2)-1) (a(i,3)+2) (a(i,4)+2)];
                j = j + 1;
            end
            
        end      
    end
end

function cond = isCharacter(img, a)
    %img = rgb2gray(img);
    cp = imcrop(img,a(1,:));
    [h,w] = size(cp);
    
    uh = cp(round(1:h/2),:,:);
    dh = cp(round(h/2:end),:,:);
    
    au = sum(uh(:, :, 1) <= 110 & uh(:, :, 3) <= 110 & uh(:, :, 3) <= 110);
    ad = sum(dh(:, :, 1) <= 110 & dh(:, :, 3) <= 110 & dh(:, :, 3) <= 110);
    
    threshold = ((h*w*0.01)/2);
    au = sum(au(:));
    ad = sum(ad(:));
    %aux = find(cp < 60);
    %count = size(aux,1)
    %threshold = (h*w*0.1)
    %rand = -1
    cond = au > threshold && ad > threshold;
end
    