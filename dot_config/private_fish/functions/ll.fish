# Alias for `exa`
function ll
  exa -all --long --header --group --icons --group-directories-first --sort=name $argv
end
