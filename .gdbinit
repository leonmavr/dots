set disassembly-flavor intel
set confirm off
set debuginfod enabled on
set auto-load safe-path

define whereami
  info line *$pc
end

# Short alias
define wa
  whereami
end

# NOTE: needs rr (rr-debugger) installed
define rs
    reverse-step
end

define rn
    reverse-next
end

define rc
    reverse-continue
end
