set -e
python3 make.py
/opt/pw-browsers/chromium-1194/chrome-linux/chrome --headless --no-sandbox --disable-gpu --no-pdf-header-footer --print-to-pdf=out.pdf --virtual-time-budget=5000 file://$PWD/index.html 2>/dev/null
python3 -c "
import pymupdf;d=pymupdf.open('out.pdf');print('pdf pages',len(d))
for i,p in enumerate(d): p.get_pixmap(dpi=72).save(f'p{i+1:02d}.png')
"
