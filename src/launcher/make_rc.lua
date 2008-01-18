
io.write("#define IDS_WSAPI 1\r\n")
io.write("STRINGTABLE\r\nBEGIN\r\n")
io.write("IDS_WSAPI \"")
io.write("package.path = \"\"" .. package.path .. "\"\"\\n\\\r\n")

for line in io.lines((...)) do
  if not line:match("^#!") then
    line = line:gsub('"', '""'):gsub("[\r\n]+", "")
    io.write(line .. "\\n\\\r\n")
  end
end

io.write("\"\r\nEND\r\n")
