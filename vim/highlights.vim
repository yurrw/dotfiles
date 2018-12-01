set list
set listchars=tab:\|\ 
set fillchars=vert:│,stlnc:=
hi VertSplit ctermbg=white ctermfg=black
hi NonText ctermfg=8

if has('nvim')
	hi DiffAdd ctermbg=6 ctermfg=232
	hi DiffText ctermbg=1 ctermfg=232
	hi IncSearch ctermbg=0 ctermfg=1
endif

"Highlight columns 81 and 101 on lines with that many characters
call matchadd('ColorColumn', '\%81v', 100)
call matchadd('ColorColumn', '\%101v', 100)
