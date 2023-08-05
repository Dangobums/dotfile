if status is-interactive
    # Commands to run in interactive sessions can go here
end
function __check_nvm --on-variable PWD --description 'Do nvm stuff'
  set node_version (nvm version)

  if test -f .nvmrc
    set nvmrc_node_version (nvm version (cat .nvmrc))

    if [ $nvmrc_node_version = "N/A" ]
      nvm install
    else if [ $nvmrc_node_version != $node_version ]
      nvm use
    end
  else if [ $node_version != (nvm version default) ]
    echo Reverting to nvm default version
    nvm use default
  end
end

# To check current dir upon Fish session start
__check_nvm

set PATH $HOME/.cargo/bin $PATH
set fist_greeting ""
