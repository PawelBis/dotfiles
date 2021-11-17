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
  },

  lua = {
    snippet("fn", {
      text("function "),
      insert(1),
      text("("),
      insert(2, "int foo"),
      text({ ") {", "\t" }),
      insert(0),
      text({ "", "}" }),
    })
  }
}
