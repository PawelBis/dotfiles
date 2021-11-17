local luasnip = require("luasnip")
local snippet = luasnip.snippet
local snippet_node = luasnip.snippet_node
local text = luasnip.text_node
local insert = luasnip.insert_node
local fn = luasnip.function_node
local choice = luasnip.choice_node
local dynamic = luasnip.dynamic_node

-- 1 is the text in Placeholder 1
-- etc
local function copy(args)
  return args[1]
end

luasnip.snippets = {
  rust = {
    snippet("fn", {
       text("fn "),
       insert(1),
       text("("),
       insert(2),
       text(")"),
       insert(3),
       text({ " {", "\t" }),
       insert(0),
       text({ "", "}" }),
    }),

    snippet("pfn", {
      text("pub fn "),
      insert(1),
      text("("),
      insert(2),
      text(")"),
      insert(3),
      text({ " {", "\t" }),
      insert(0),
      text({ "", "}" }),
    }),

    snippet("afn", {
      text("async fn "),
      insert(1),
      text("("),
      insert(2),
      text(")"),
      insert(3),
      text({ " {", "\t" }),
      insert(0),
      text({ "", "}" }),
    }),

    snippet("pafn", {
      text("pub async fn "),
      insert(1),
      text("("),
      insert(2),
      text(")"),
      insert(3),
      text({ " {", "\t" }),
      insert(0),
      text({ "", "}" }),
    }),

    snippet("new", {
      text("pub fn new("),
      insert(2),
      text(") -> "),
      insert(1),
      text({ " {", "\t" }),
      fn(copy, 1),
      text({ " {", "\t\t" }),
      insert(0),
      text({"", "\t}", "}"}),
    }),

    snippet("let", {
      text("let "),
      insert(1),
      text(" = "),
      insert(0),
      text({ ";", "" }),
    }),

    snippet("letm", {
      text("let mut "),
      insert(1),
      text(" = "),
      insert(0),
      text({ ";", "" }),
    }),

    snippet("lett", {
      text("let "),
      insert(1),
      text(": "),
      insert(2),
      text(" = "),
      insert(0),
      text({ ";", "" }),
    }),

    snippet("lettm", {
      text("let mut "),
      insert(1),
      text(": "),
      insert(2),
      text(" = "),
      insert(0),
      text({ ";", "" }),
    }),

    snippet("pln", {
      text("println!(\""),
      insert(0),
      text("\");"),
    }),

    snippet("as", {
      text("assert!("),
      insert(0, "Predicate"),
      text(");")
    }),

    snippet("der", {
      text("#[derive("),
      insert(0, "Debug"),
      text(")]"),
    }),

    snippet("cfg", {
      text("#[cfg("),
      insert(0, "target_os = \"linux\""),
      text(")]"),
    }),

    snippet("if", {
      text("if "),
      insert(1),
      text({ " {", "\t" }),
      insert(0),
      text({ "", "}" }),
    }),

    snippet("ife", {
      text("if "),
      insert(1),
      text({ " {", "\t" }),
      insert(2),
      text({ "", "} else {", "\t" }),
      insert(0),
      text({ "", "}" }),
    }),

    snippet("ifs", {
      text("if let Some("),
      insert(1),
      text(") = "),
      insert(2),
      text({ " { ", "\t" }),
      insert(0),
      text({ "", "}" }),
    }),

    snippet("ifo", {
      text("if let Ok("),
      insert(1),
      text(") = "),
      insert(2),
      text({ " { ", "\t" }),
      insert(0),
      text({ "", "}" }),
    }),

    snippet("for", {
      text("for "),
      insert(1),
      text(" in "),
      insert(2),
      text({ " {", "\t" }),
      insert(0),
      text({ "", "}" })
    }),

    snippet("mat", {
      text("match "),
      insert(1),
      text({ " {", "\t" }),
      insert(2),
      text(" => "),
      insert(0),
      text({ ",", "}" }),
    }),

    snippet("case", {
      insert(1),
      text(" => "),
      insert(0),
      text(",")
    }),
  },

  lua = {
    snippet("fn", {
      text("function "),
      insert(1),
      text("("),
      insert(2),
      text({ ")", "\t" }),
      insert(0),
      text({ "", "end" }),
    })
  }
}

