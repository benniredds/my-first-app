#!/usr/bin/env node

/* eslint-env node */

// this shim is necessary to work around an issue when the first two lines of the file start with:

// #!/usr/bin/env node
// module.exports

// npm seems to parse the second line as part of the shebang, breaking its autogenerated shims

require("../dist/index.js");