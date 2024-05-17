
function XD(memory, bytes) {
  function ascii_to_hex(n, pad_to) {
    s = n.toString(16);
    while (s.length < pad_to) {
      s = '0' + s;
    }
    return s;
  }

  var i = 0;
  var j = i;
  var m = memory;
  var last_ascii = 0;
  var ascii = '';
  var a_byte = '';
  var xd = '';
  for (i = 0; i < bytes; ++i) {
    if ((i % 16) == 0) {
      xd += ascii_to_hex(i, 8);
    }
    xd += ascii_to_hex(m.charCodeAt(i), 2);
    if ((i % 2) == 1) {
      xd += ' ';
    }
    if ((i % 16) == 15) {
      xd += ' ';
      for (j = last_ascii; j <= i; ++j) {
        a_byte = m.charCodeAt(j);
        if (' ' < a_byte && a_byte <= '~') {
          ascii = a_byte;
        } else {
          ascii = '.';
        }
        xd += ascii;
      }
      last_ascii = i
      xd += '\n';
    }
  }
}
