md5_input = $("#md5-input")
md5_output = $("#md5-output")
md5_input.on "keyup change", () -> md5_output.val(CryptoJS.MD5(md5_input.val()))

sha1_input = $("#sha1-input")
sha1_output = $("#sha1-output")
sha1_input.on "keyup change", () -> sha1_output.val(CryptoJS.SHA1(sha1_input.val()))
