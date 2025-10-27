# OpenEng.jl

[![CI](https://github.com/TheusHen/OpenEng.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/TheusHen/OpenEng.jl/actions/workflows/CI.yml)
[![Documentation](https://github.com/TheusHen/OpenEng.jl/actions/workflows/Documentation.yml/badge.svg)](https://github.com/TheusHen/OpenEng.jl/actions/workflows/Documentation.yml)
[![codecov](https://codecov.io/gh/TheusHen/OpenEng.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/TheusHen/OpenEng.jl)

**OpenEng.jl** é uma toolbox científica open-source em Julia que substitui o MATLAB com desempenho superior. Inclui módulos para álgebra linear, simulação de sistemas, processamento de sinais, otimização e visualização 2D/3D. Suporta GPU, IA e controle, sendo ideal para estudantes, engenheiros e pesquisadores que buscam poder, velocidade e liberdade.

## ✨ Características

- 🧮 **Álgebra Linear Avançada**: Operações matriciais otimizadas com suporte a GPU
- 📊 **Processamento de Sinais**: Análise espectral, filtros e transformadas
- 🎛️ **Sistemas de Controle**: Simulação e análise de sistemas dinâmicos
- 📈 **Otimização**: Algoritmos modernos de otimização numérica
- 🎨 **Visualização**: Gráficos 2D/3D interativos e de alta qualidade

## 🚀 Instalação

```julia
using Pkg
Pkg.add("OpenEng")
```

Ou no modo Pkg (pressione `]` no REPL):

```julia-repl
pkg> add OpenEng
```

## 📖 Início Rápido

```julia
using OpenEng

# Mensagem de boas-vindas
OpenEng.greet()

# Mais exemplos serão adicionados conforme os módulos são desenvolvidos
```

## 🎯 Público-Alvo

- **Estudantes**: Aprenda computação científica com ferramentas modernas e gratuitas
- **Engenheiros**: Substitua MATLAB com melhor desempenho e sem custos de licença
- **Pesquisadores**: Acesse poder computacional máximo com liberdade open-source

## 📚 Documentação

Documentação completa disponível em: [TheusHen.github.io/OpenEng.jl](https://TheusHen.github.io/OpenEng.jl)

## 🏗️ Estrutura do Projeto

```
OpenEng.jl/
├── src/
│   └── OpenEng.jl          # Módulo principal
├── test/
│   └── runtests.jl         # Testes automatizados
├── docs/
│   ├── make.jl             # Script de documentação
│   └── src/
│       ├── index.md        # Página inicial da documentação
│       └── api.md          # Referência da API
├── .github/
│   └── workflows/
│       ├── CI.yml          # Integração contínua
│       └── Documentation.yml # Deploy de documentação
├── Project.toml            # Metadados e dependências
├── LICENSE                 # Licença MIT
└── README.md               # Este arquivo
```

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor, sinta-se à vontade para:

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🌟 Status do Projeto

Este projeto está em desenvolvimento ativo. Módulos adicionais serão implementados progressivamente.

### Roadmap

- [x] Estrutura básica do pacote
- [x] Configuração de CI/CD
- [x] Documentação inicial
- [ ] Módulo de Álgebra Linear
- [ ] Módulo de Processamento de Sinais
- [ ] Módulo de Sistemas de Controle
- [ ] Módulo de Otimização
- [ ] Módulo de Visualização
- [ ] Suporte a GPU
- [ ] Integração com IA/ML

## 📧 Contato

TheusHen - [@TheusHen](https://github.com/TheusHen)

Link do Projeto: [https://github.com/TheusHen/OpenEng.jl](https://github.com/TheusHen/OpenEng.jl)