* Set up github repository:
cap cd "C:/Users/Rodrigo/Desktop/ARM" 
! echo # github-tutorial  >> README.md
! git init
! git add README.md
! git commit -m "initial commit, only README"
! git remote add origin https://github.com/rodrigofcaba/ARM.git
! git push -u origin master

* First commit:
file close _all
file open git using mygit.bat, write replace
file write git "git remote add origin " `"""' "https://github.com/rodrigofcaba/ARM.git" `"""' _n
file write git "git add --all" _n
file write git "git commit -m "
file write git `"""' "initial commit" `"""' _n
file write git "git push" _n
file close git
! mygit.bat

* RUN TO PUSH CHANGES TO GITHUB:
file close _all
file open git using mygit.bat, write replace
file write git "git add --all" _n
file write git "git commit -m "
file write git `"""' "new graphs and variable recoding/labeling" `"""' _n
file write git "git push" _n
file close git
! mygit.bat