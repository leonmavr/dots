set disassembly-flavor intel
set confirm off
set debuginfod enabled on

define whereami
  info line *$pc
end

# Short alias
define wa
  whereami
end
