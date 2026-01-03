In this directory (after/lsp) you can put the configs for the lsps that you want which will be overwrite the defaults. The syntax is roughfly this:
- capabilities: {
	offsetEncoding = { "utf-8", "utf-16" },
				   textDocument = {
					   completion = {
						   completionItem = {
							   commitCharactersSupport = true,
							   deprecatedSupport = true,
							   insertReplaceSupport = true,
							   insertTextModeSupport = {
								   valueSet = { 1, 2 }
							   },
							   labelDetailsSupport = true,
							   preselectSupport = true,
							   resolveSupport = {
								   properties = { "documentation", "additionalTextEdits", "insertTextFormat", "insertTextMode", "command" }
							   },
							   snippetSupport = true,
							   tagSupport = {
								   valueSet = { 1 }
							   }
						   },
						   completionList = {
							   itemDefaults = { "commitCharacters", "editRange", "insertTextFormat", "insertTextMode", "data" }
						   },
						   contextSupport = true,
						   dynamicRegistration = false,
						   editsNearCursor = true,
						   insertTextMode = 1
					   }
				   }
}
- cmd: { "clangd" }
- filetypes: c, cpp, objc, objcpp, cuda
- on_attach: <function @/home/mak_mart/.config/nvim/after/lsp/clangd.lua:2>
- on_init: <function @/home/mak_mart/.local/share/nvim/lazy/nvim-lspconfig/lsp/clangd.lua:86>
- root_markers: { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", "configure.ac", ".git" }
