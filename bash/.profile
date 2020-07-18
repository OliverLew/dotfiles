#!/bin/sh
# PATH
for p in "$HOME/.gem/ruby" "$HOME/.local/bin" "$HOME/.local/share/npm/bin"; do
    if [ -d "$p" ] && [ "$PATH" = "${PATH%$p*}" ]; then
        export PATH="$p:${PATH}"
    fi
done

# Environments
export EDITOR=vim
export VISUAL=vim
export NOTES_DIRECTORY="$HOME/Code/notes"
export FBFONT="/usr/share/kbd/consolefonts/ter-216n.psf.gz"

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export LESSHISTFILE=-
export ELINKS_CONFDIR="$XDG_CONFIG_HOME/elinks"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/ipython"
export MATHEMATICA_USERBASE="$XDG_CONFIG_HOME/Mathematica"
export PASSWORD_STORE_DIR="$XDG_CONFIG_HOME/password-store"
export MPLAYER_HOME="$XDG_CONFIG_HOME/mplayer"
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"
export GRIPHOME="$XDG_CONFIG_HOME/grip"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export RXVT_SOCKET="$XDG_RUNTIME_DIR/urxvtd"
export ABDUCO_SOCKET_DIR="$XDG_RUNTIME_DIR"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss"
export MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
export MYGVIMRC="$XDG_CONFIG_HOME/vim/vimrc"
export EXINIT=":source $XDG_CONFIG_HOME/ex/exrc"
export VIMINIT=":source $MYVIMRC"
export ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export RANDFILE="$XDG_CACHE_HOME/openssl_rnd"

export LYNX_CFG="$XDG_CONFIG_HOME/lynx/lynx.cfg"
export LYNX_LSS="$XDG_CONFIG_HOME/lynx/lynx.lss"

# Set icons in lf
export LF_ICONS="\
.git=:\
Desktop=:\
Documents=:\
Downloads=:\
Dotfiles=:\
Dropbox=:\
Music=:\
Pictures=:\
Public=:\
Templates=:\
Videos=:\
*.7z=:\
*.7z=:\
*.a=:\
*.aac=:\
*.ace=:\
*.ai=:\
*.alz=:\
*.apk=:\
*.arc=:\
*.arj=:\
*.asf=:\
*.asm=:\
*.asp=:\
*.au=:\
*.aup=:\
*.avi=:\
*.avi=:\
*.bash=:\
*.bat=:\
*.bmp=:\
*.bmp=:\
*.bz2=:\
*.bz2=:\
*.bz=:\
*.c++=:\
*.c=:\
*.c=:\
*.cab=:\
*.cab=:\
*.cbr=:\
*.cbz=:\
*.cc=:\
*.cc=:\
*.cgm=:\
*.class=:\
*.clj=:\
*.clj=:\
*.cljc=:\
*.cljs=:\
*.cmake=:\
*.cmd=:\
*.coffee=:\
*.coffee=:\
*.conf=:\
*.cp=:\
*.cpio=:\
*.cpio=:\
*.cpp=:\
*.cpp=:\
*.cs=:\
*.css=:\
*.css=:\
*.cue=:\
*.cvs=:\
*.cxx=:\
*.d=:\
*.d=:\
*.dart=:\
*.dart=:\
*.db=:\
*.deb=:\
*.deb=:\
*.diff=:\
*.dl=:\
*.dll=:\
*.doc=:\
*.docx=:\
*.dump=:\
*.dwm=:\
*.dz=:\
*.ear=:\
*.edn=:\
*.efi=:\
*.ejs=:\
*.elf=:\
*.emf=:\
*.epub=:\
*.erl=:\
*.erl=:\
*.esd=:\
*.exe=:\
*.exs=:\
*.f#=:\
*.fifo=|:\
*.fish=:\
*.fish=:\
*.flac=:\
*.flac=:\
*.flc=:\
*.fli=:\
*.flv=:\
*.flv=:\
*.fs=:\
*.fs=:\
*.fsi=:\
*.fsscript=:\
*.fsx=:\
*.gem=:\
*.gif=:\
*.gif=:\
*.gitignore=:\
*.gl=:\
*.go=:\
*.go=:\
*.gz=:\
*.gz=:\
*.gzip=:\
*.h=:\
*.h=:\
*.hbs=:\
*.hh=:\
*.hpp=:\
*.hrl=:\
*.hs=:\
*.hs=:\
*.htaccess=:\
*.htm=:\
*.html=:\
*.html=:\
*.htpasswd=:\
*.ico=:\
*.img=:\
*.ini=:\
*.iso=:\
*.jar=:\
*.jar=:\
*.java=:\
*.java=:\
*.jl=:\
*.jl=:\
*.jpeg=:\
*.jpeg=:\
*.jpg=:\
*.jpg=:\
*.js=:\
*.js=:\
*.json=:\
*.json=:\
*.jsx=:\
*.key=:\
*.less=:\
*.lha=:\
*.lha=:\
*.lhs=:\
*.log=:\
*.lrz=:\
*.lua=:\
*.lua=:\
*.lz4=:\
*.lz=:\
*.lzh=:\
*.lzh=:\
*.lzma=:\
*.lzma=:\
*.lzo=:\
*.m2v=:\
*.m4a=:\
*.m4a=:\
*.m4v=:\
*.m4v=:\
*.markdown=:\
*.md=:\
*.md=:\
*.mid=:\
*.midi=:\
*.mjpeg=:\
*.mjpg=:\
*.mka=:\
*.mkv=:\
*.mkv=:\
*.ml=λ:\
*.mli=λ:\
*.mng=:\
*.mov=:\
*.mov=:\
*.mp3=:\
*.mp3=:\
*.mp4=:\
*.mp4=:\
*.mp4v=:\
*.mpc=:\
*.mpeg=:\
*.mpeg=:\
*.mpg=:\
*.mpg=:\
*.msi=:\
*.mustache=:\
*.nix=:\
*.nuv=:\
*.o=:\
*.oga=:\
*.ogg=:\
*.ogg=:\
*.ogm=:\
*.ogv=:\
*.ogx=:\
*.opus=:\
*.pbm=:\
*.pcx=:\
*.pdf=:\
*.pdf=:\
*.pgm=:\
*.php=:\
*.php=:\
*.pl=:\
*.pl=:\
*.pm=:\
*.png=:\
*.png=:\
*.ppm=:\
*.ppt=:\
*.pptx=:\
*.pro=:\
*.ps1=:\
*.psb=:\
*.psd=:\
*.pub=:\
*.py=:\
*.py=:\
*.pyc=:\
*.pyd=:\
*.pyo=:\
*.qt=:\
*.ra=:\
*.rar=:\
*.rar=:\
*.rb=:\
*.rb=:\
*.rc=:\
*.rlib=:\
*.rm=:\
*.rmvb=:\
*.rom=:\
*.rpm=:\
*.rpm=:\
*.rs=:\
*.rs=:\
*.rss=:\
*.rtf=:\
*.rz=:\
*.s=:\
*.sar=:\
*.scala=:\
*.scala=:\
*.scss=:\
*.sh=:\
*.sh=:\
*.slim=:\
*.sln=:\
*.so=:\
*.spx=:\
*.sql=:\
*.styl=:\
*.suo=:\
*.svg=:\
*.svgz=:\
*.swm=:\
*.t7z=:\
*.t=:\
*.tar=:\
*.tar=:\
*.taz=:\
*.tbz2=:\
*.tbz=:\
*.tga=:\
*.tgz=:\
*.tgz=:\
*.tif=:\
*.tiff=:\
*.tlz=:\
*.ts=:\
*.ts=:\
*.twig=:\
*.txz=:\
*.tz=:\
*.tzo=:\
*.tzst=:\
*.vim=:\
*.vim=:\
*.viminfo=:\
*.vimrc=:\
*.vimrc=:\
*.vob=:\
*.war=:\
*.wav=:\
*.wav=:\
*.webm=:\
*.webm=:\
*.wim=:\
*.wmv=:\
*.xbm=:\
*.xbps=:\
*.xcf=:\
*.xhtml=:\
*.xls=:\
*.xlsx=:\
*.xml=:\
*.xpm=:\
*.xspf=:\
*.xul=:\
*.xwd=:\
*.xz=:\
*.xz=:\
*.yaml=:\
*.yml=:\
*.yuv=:\
*.z=:\
*.zip=:\
*.zip=:\
*.zoo=:\
*.zsh=:\
*.zst=:\
di=:\
ex=:\
fi=:\
ln=:\
or=:\
"
