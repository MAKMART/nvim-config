return {
	on_attach = function(client, bufnr)
		-- Disable semantic tokens (LSP coloring)
		--client.server_capabilities.semanticTokensProvider = nil
	end
}
