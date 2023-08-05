function grepXNode
      grep -rn --exclude-dir=node_modules --exclude='*.json' $argv | awk -F ':' '!a[$1]++ {print "File: " $1} {print $2 ", " $0}'
end
