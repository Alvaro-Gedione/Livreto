# Paths for Meet360 project
$projects = @(
    @{ 
        Origem   = "E:\Softwares\Livreto"; 
        Destino  = "E:\Softwares\Livreto\tudo_combinado\txt_geral"; 
        Final    = "E:\Softwares\Livreto\tudo_combinado\tudo_combinado_Livreto.txt";
        Filtro   = "*"
        excessao = "tudo_combinado" # Pasta a ser excluída
    }
)

foreach ($p in $projects) {
    # Ensure directories exist
    if (!(Test-Path $p.Destino)) { New-Item -ItemType Directory -Path $p.Destino | Out-Null }
    if (!(Test-Path (Split-Path $p.Final))) { New-Item -ItemType Directory -Path (Split-Path $p.Final) | Out-Null }

    $conteudoAcumulado = New-Object System.Collections.Generic.List[string]

    # Ajuste aqui: Filtrando para NÃO processar a pasta de destino e a excessão
    Get-ChildItem -Path $p.Origem -Recurse -File -Filter $p.Filtro | Where-Object { 
        $_.FullName -notlike "$($p.Destino)*" -and 
        $_.FullName -ne $p.Final -and 
        $_.FullName -notmatch [regex]::Escape($p.excessao)
    } | ForEach-Object {
        
        $caminhoRelativo = $_.FullName.Substring($p.Origem.Length).TrimStart('\')
        # Substitui caracteres que podem quebrar o caminho do arquivo
        $nomeFinal = ($caminhoRelativo.Replace('\', '_').Replace(':', '_')) + ".txt"
        $destinoIndividual = Join-Path $p.Destino $nomeFinal

        # Read the source file
        try {
            $fileContent = Get-Content $_.FullName -Raw -ErrorAction Stop

            # Save individual txt copy
            $fileContent | Set-Content $destinoIndividual

            # Add to the list with headers
            $conteudoAcumulado.Add("`n#### Inicio de $nomeFinal ####`n")
            $conteudoAcumulado.Add($fileContent)
            $conteudoAcumulado.Add("`n#### Fim de $nomeFinal ####`n")
        } catch {
            Write-Warning "Nao foi possivel ler o arquivo: $($_.FullName)"
        }
    }

    # Write everything at once
    $conteudoAcumulado | Out-File -FilePath $p.Final -Encoding utf8 -Force
    Write-Host "Concluido: $($p.Final)" -ForegroundColor Green
}
