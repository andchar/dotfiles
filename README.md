# dotfiles

#VIM configuration

#prerequisits
yarnpkg

```bash
#rm -rf ~/.vim
cp -r .vim/ ~/
vim -c PluginInstall
cd ~/.vim/bundle/coc.nvim && yarn install && cd -
```
