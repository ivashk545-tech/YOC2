set -e
python3 make_m.py
C=/opt/pw-browsers/chromium-1194/chrome-linux/chrome
$C --headless --no-sandbox --disable-gpu --window-size=640,1138 --virtual-time-budget=5000 --dump-dom file://$PWD/index_m.html 2>/dev/null | grep -o 'data-over="[^"]*"'
$C --headless --no-sandbox --disable-gpu --no-pdf-header-footer --print-to-pdf=out_m.pdf --virtual-time-budget=5000 file://$PWD/index_m.html 2>/dev/null
python3 -c "
import pymupdf;d=pymupdf.open('out_m.pdf');print('pdf pages',len(d), d[0].rect)
for i,p in enumerate(d): p.get_pixmap(dpi=48).save(f'm{i+1:02d}.png')
from PIL import Image
n=len(d);cols=8
w,h=Image.open('m01.png').size
for k in range(0,n,cols*2):
  s=Image.new('RGB',((w+8)*cols,(h+8)*2),'black')
  for j in range(k,min(n,k+cols*2)):
    im=Image.open(f'm{j+1:02d}.png');jj=j-k;s.paste(im,((jj%cols)*(w+8),(jj//cols)*(h+8)))
  s.save(f'msheet{k//(cols*2)+1}.png')
"
