# -*- mode: python -*-
a = Analysis(['userintvoff.py'],
             pathex=['C:\\Users\\Lee\\Google Drive\\Research\\programming\\Code\\diode model'],
             hiddenimports=['scipy.special._ufuncs_cxx'],
             hookspath=None,
             runtime_hooks=None)
pyz = PYZ(a.pure)
exe = EXE(pyz,
          a.scripts,
          exclude_binaries=True,
          name='userintvoff.exe',
          debug=False,
          strip=None,
          upx=True,
          console=True )
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=None,
               upx=True,
               name='userintvoff')
