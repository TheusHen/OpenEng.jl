# Contribuindo para OpenEng.jl

Obrigado por considerar contribuir para o OpenEng.jl! 🎉

## Como Contribuir

### Reportando Bugs

Se você encontrou um bug, por favor:

1. Verifique se o bug já não foi reportado nas [Issues](https://github.com/TheusHen/OpenEng.jl/issues)
2. Se não foi, abra uma nova issue incluindo:
   - Descrição clara do problema
   - Código mínimo para reproduzir
   - Versão do Julia e do OpenEng.jl
   - Mensagem de erro completa (se aplicável)

### Sugerindo Melhorias

Para sugerir novas funcionalidades:

1. Abra uma issue com a tag `enhancement`
2. Descreva claramente a funcionalidade desejada
3. Explique por que ela seria útil
4. Forneça exemplos de uso, se possível

### Pull Requests

1. Faça fork do repositório
2. Crie uma branch para sua feature:
   ```bash
   git checkout -b feature/MinhaNovaFeature
   ```
3. Faça suas alterações seguindo o estilo de código do projeto
4. Adicione testes para novas funcionalidades
5. Certifique-se de que todos os testes passam:
   ```julia
   using Pkg
   Pkg.test("OpenEng")
   ```
6. Commit suas mudanças:
   ```bash
   git commit -m 'Adiciona MinhaNovaFeature'
   ```
7. Push para a branch:
   ```bash
   git push origin feature/MinhaNovaFeature
   ```
8. Abra um Pull Request

## Guia de Estilo

### Código Julia

- Use 4 espaços para indentação
- Nomes de funções em `snake_case` ou `camelCase` conforme convenções Julia
- Documente funções públicas com docstrings
- Mantenha linhas com no máximo 92 caracteres
- Use o JuliaFormatter para formatar o código:
  ```julia
  using JuliaFormatter
  format("src/")
  ```

### Commits

- Use mensagens de commit descritivas em português ou inglês
- Prefira commits pequenos e focados
- Siga o padrão:
  - `feat:` para novas funcionalidades
  - `fix:` para correções de bugs
  - `docs:` para documentação
  - `test:` para testes
  - `refactor:` para refatorações

### Testes

- Adicione testes para toda nova funcionalidade
- Mantenha cobertura de testes alta
- Testes devem ser rápidos e independentes
- Use `@testset` para organizar testes relacionados

### Documentação

- Documente todas as funções públicas
- Use markdown para documentação
- Inclua exemplos de uso quando relevante
- Mantenha a documentação atualizada com o código

## Estrutura do Projeto

```
OpenEng.jl/
├── src/                    # Código fonte
│   └── OpenEng.jl         # Módulo principal
├── test/                   # Testes
│   └── runtests.jl
├── docs/                   # Documentação
│   ├── make.jl
│   └── src/
├── .github/                # GitHub Actions
│   └── workflows/
└── Project.toml           # Dependências
```

## Configuração do Ambiente de Desenvolvimento

1. Clone o repositório:
   ```bash
   git clone https://github.com/TheusHen/OpenEng.jl.git
   cd OpenEng.jl
   ```

2. Instale as dependências:
   ```julia
   using Pkg
   Pkg.activate(".")
   Pkg.instantiate()
   ```

3. Execute os testes:
   ```julia
   Pkg.test()
   ```

## Código de Conduta

Este projeto adota um código de conduta que esperamos que todos os participantes sigam:

- Seja respeitoso e inclusivo
- Aceite críticas construtivas
- Foque no que é melhor para a comunidade
- Mostre empatia com outros membros

## Dúvidas?

Se tiver dúvidas sobre como contribuir, sinta-se à vontade para:

- Abrir uma issue
- Entrar em contato através do GitHub

Obrigado por contribuir para o OpenEng.jl! 🚀
