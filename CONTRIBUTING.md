# Contributing to OpenEng.jl

Thank you for your interest in contributing to OpenEng.jl! This document provides guidelines and instructions for contributing.

## 🌟 Ways to Contribute

- **Report bugs** via GitHub Issues
- **Suggest features** and enhancements
- **Improve documentation** and examples
- **Submit pull requests** with bug fixes or new features
- **Help others** in discussions and issues

## 🚀 Getting Started

### 1. Fork and Clone

```bash
git clone https://github.com/YOUR_USERNAME/OpenEng.jl.git
cd OpenEng.jl
```

### 2. Set Up Development Environment

```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

### 3. Create a Branch

```bash
git checkout -b feature/your-feature-name
```

## 🧪 Testing

Always run tests before submitting:

```bash
julia --project=. -e 'using Pkg; Pkg.test()'
```

Add tests for new features in the `test/` directory.

## 📝 Code Style

- Follow [Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/)
- Use meaningful variable names
- Add docstrings to all public functions
- Keep functions focused and modular
- Comment complex algorithms

### Example Docstring

```julia
"""
    my_function(x::Float64, y::Float64) -> Float64

Compute something useful with `x` and `y`.

# Arguments
- `x::Float64`: First parameter
- `y::Float64`: Second parameter

# Returns
- `Float64`: The computed result

# Examples
```julia
result = my_function(3.0, 4.0)
```
"""
function my_function(x::Float64, y::Float64)
    return x + y
end
```

## 📦 Pull Request Process

1. **Update documentation** if needed
2. **Add tests** for new functionality
3. **Ensure all tests pass**
4. **Update CHANGELOG.md** (if applicable)
5. **Submit PR** with clear description

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
Describe how you tested the changes

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Code follows style guide
```

## 🐛 Reporting Bugs

Include:
- Julia version
- OpenEng.jl version
- Minimal reproducible example
- Expected vs actual behavior
- Error messages and stack traces

## 💡 Suggesting Features

When suggesting features:
- Explain the use case
- Describe the expected API
- Consider implementation complexity
- Check if it aligns with project goals

## 📚 Documentation

- Documentation lives in `docs/`
- Examples go in `examples/`
- Use clear, concise English
- Include code examples
- Build docs locally: `julia --project=docs docs/make.jl`

## 🤝 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Assume good intentions

## 📧 Questions?

Feel free to ask in:
- GitHub Discussions
- GitHub Issues (for technical questions)

## 🙏 Thank You!

Every contribution, no matter how small, is valuable to the project!
