M=math
pi=M.pi
pi2=pi*2
si=M.sin
co=M.cos
S=screen
dL=S.drawLine
dCF=S.drawCircleF
dTF=S.drawTriangleF
dTB=S.drawTextBox
C=S.setColor
I=input
O=output
P=property
prB=P.getBool
prN=P.getNumber
tU=table.unpack
tP=table.pack

function getN(...)local a={}for b,c in ipairs({...})do a[b]=I.getNumber(c)end;return tU(a)end
function getB(...)local a={}for b,c in ipairs({...})do a[b]=I.getBool(c)end;return tU(a)end
function drawArc(...)local a,b,c,d,e,f,g=...d=d or 0;e=e or 360;g=g or 22.5;if e<d then e,d=d,e end;local h,i,j,k,l,m=false,0,0,0,0,0;repeat h=h and M.min(h+g,e)or d;m=(h-90)*pi/180;i,j=a+c*co(m),b+c*si(m)if h~=d then if f then dTF(a,b,k,l,i,j)else dL(k,l,i,j)end end;k,l=i,j until h>=e end
function getArcBox(...)local cx,cy,r,th = ... u = cy-r;b = M.max(cy,cy-r*co(th*pi2));l = th>0.25 and cx-r or cx-r*si(th*pi2);r = th>0.25 and cx+r or cx+r*si(th*pi2) return u,b,l,r end

slim=prN('Sweep Limit/100')/100
fovx=prN('FOV X/100')/100
zoom=tP(prN('Zoom1'),prN('Zoom2'),prN('Zoom3'))
slim=M.min(0.5,slim+fovx/2)

coef=1
conf=255
data={}
ptch=false
cx,cy,cr=0,0,0
zoomlevel=0
	
function onTick()			
	scan=M.atan(M.tan(getN(32)*pi))/pi			
	if prB('Direction')==false then
		scan=-scan
	end
	tx,ty=getN(30,31)
	tch=getB(32)	
	for i=0,7 do
		if getB(i+1)==true then		
			update=false
			point=tP(getN(4*i+1,4*i+2,4*i+3))
			if prB('Direction')==false then
				point[2],point[3]=-point[2],-point[3]
			end									
			if prB('On Pivot')==true then
				point[2]=scan+point[2]
			end	
			point[4],point[5]=conf,1		
			lscore=-1
			for k,v in ipairs(data) do
				scoreA = M.sqrt((v[2]-point[2])^2+(v[3]-point[3])^2)
				scoreD = M.sqrt((v[1]-point[1])^2/point[1]^2)	
				score = scoreA+scoreD	
				if lscore<0 then lscore=score end
				if score<lscore and scoreD<0.05 then 
					lscore=score
					lk=k
					update=true 
				end
			end
			if update==true then
				alpha=(data[lk][5]-1)/data[lk][5]
				data[lk][1],data[lk][2],data[lk][3]=alpha*data[lk][1]+(1-alpha)*point[1],
				alpha*data[lk][2]+(1-alpha)*point[2],
				alpha*data[lk][3]+(1-alpha)*point[3]
				data[lk][4]=conf
				data[lk][5]=M.min(20,data[lk][5]+1)
			else
			 table.insert(data,point) 
			end			
		else
			break
		end
	end
	if #data>0 then
		for i = #data,1,-1 do
			data[i][4]=data[i][4]-1
			if data[i][4]<0 then table.remove(data,i) end
		end
	end	
	if tch==true and ptch==false then 
		zoomlevel=(zoomlevel+1)%3
	end	
	range=zoom[zoomlevel+1]
	ptch=tch
end

function onDraw()	
    w,h =  S.getWidth(), S.getHeight(); r = M.min(w,h)/2; up,bot,left,right=getArcBox(w/2,h/2,r,slim); bx,by=right-left, bot-up
    if bx<w or by<h then coef=M.min(w/bx,h/by) end
	up,bot,left,right=getArcBox(w/2,h/2,r*coef,slim); bx,by=right-left, bot-up; stride=h/2-(up+by/2); cx,cy,cr=w/2,h/2+stride,r*coef
    C(0,64,0,127)
    drawArc(cx,cy,cr,-slim*360,slim*360,true,3)
    drawArc(cx,cy,cr,-slim*360,slim*360,false,3)
	for cf=0.25,0.75,0.25 do drawArc(cx,cy,cr*cf,-slim*360,slim*360,false,3) end
    if slim<0.5 then
	    dL(cx,cy-1,cx-cr*si(slim*pi2),cy-cr*co(slim*pi2)-1)
	    dL(cx,cy-1,cx+cr*si(slim*pi2),cy-cr*co(slim*pi2)-1)
    	C(0,64,0,127)
    	drawArc(cx,cy,cr,(M.max(-slim,scan-fovx/2)*360),(M.min(slim,scan+fovx/2)*360),true,3)
    else
    	drawArc(cx,cy,cr,((scan-fovx/2)*360),((scan+fovx/2)*360),true,3)
    end
	for k,v in ipairs(data) do
		if v[1]<range then
			px,py=cx+cr*si(v[2]*pi2)*(v[1]/range),cy-cr*co(v[2]*pi2)*(v[1]/range)
    		C(255,127,0,v[4])
		    dCF(px,py,M.max(0.5,cr/100))
		end
	end	
    C(0,255,0,127)
	strRange=string.format("%.1fkm",range/1000)
	dTB(0,h-5,w,5,strRange,1,1)
end
